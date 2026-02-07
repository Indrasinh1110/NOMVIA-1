import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat.dart';
import '../state/app_state.dart';

class ChatThreadScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserPhotoUrl;

  const ChatThreadScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPhotoUrl,
  });

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final appState = AppState.instance;
  final _messageController = TextEditingController();
  final _messages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _messages.addAll([
      ChatMessage(
        id: '1',
        chatId: widget.chatId,
        senderId: widget.otherUserId,
        senderName: widget.otherUserName,
        senderPhotoUrl: widget.otherUserPhotoUrl,
        message: 'Hello! How can I help you?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      if (appState.currentUser != null)
        ChatMessage(
          id: '2',
          chatId: widget.chatId,
          senderId: appState.currentUser!.id,
          senderName: appState.currentUser!.name,
          senderPhotoUrl: appState.currentUser!.photoUrl,
          message: 'I have a question about the trip.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || appState.currentUser == null) {
      return;
    }

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: widget.chatId,
        senderId: appState.currentUser!.id,
        senderName: appState.currentUser!.name,
        senderPhotoUrl: appState.currentUser!.photoUrl,
        message: _messageController.text.trim(),
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm');
    bool isOwnMessage(String senderId) =>
        appState.currentUser?.id == senderId;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.otherUserPhotoUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUserName,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Report'),
                  content: const Text('Report this conversation?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reported')),
                        );
                      },
                      child: const Text('Report'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final own = isOwnMessage(message.senderId);
                return Align(
                  alignment: own ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          own ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!own)
                          CircleAvatar(
                            radius: 12,
                            backgroundImage:
                                NetworkImage(message.senderPhotoUrl),
                          ),
                        if (!own) const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: own ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.message,
                                  style: TextStyle(
                                    color: own ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateFormat.format(message.timestamp),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: own
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (own) const SizedBox(width: 8),
                        if (own)
                          CircleAvatar(
                            radius: 12,
                            backgroundImage:
                                NetworkImage(message.senderPhotoUrl),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
