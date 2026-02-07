import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app/app_router.dart';
import '../state/app_state.dart';
import '../models/chat.dart';

class ChatInboxScreen extends StatefulWidget {
  const ChatInboxScreen({super.key});

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  final appState = AppState.instance;

  List<Chat> get agencyChats {
    if (appState.currentUser == null) return [];
    final chats = <Chat>[];
    for (var agency in appState.agencies) {
      chats.add(Chat(
        id: 'chat_${appState.currentUser!.id}_${agency.id}',
        type: 'agency',
        otherUserId: agency.id,
        otherUserName: agency.name,
        otherUserPhotoUrl: agency.logoUrl,
        lastMessage: 'Hello, I have a question about your trips.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 1,
      ));
    }
    return chats;
  }

  List<Chat> get friendChats {
    if (appState.currentUser == null) return [];
    final chats = <Chat>[];
    for (var friendId in appState.currentUser!.friendIds) {
      final friend = appState.users.firstWhere(
        (u) => u.id == friendId,
        orElse: () => appState.users.first,
      );
      chats.add(Chat(
        id: 'chat_${appState.currentUser!.id}_$friendId',
        type: 'friend',
        otherUserId: friend.id,
        otherUserName: friend.name,
        otherUserPhotoUrl: friend.photoUrl,
        lastMessage: 'Hey! Are you joining the trip?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 0,
      ));
    }
    return chats;
  }

  @override
  Widget build(BuildContext context) {
    final agencies = agencyChats;
    final friends = friendChats;
    final dateFormat = DateFormat('MMM dd, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView(
        children: [
          if (agencies.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Agencies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...agencies.map((chat) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat.otherUserPhotoUrl),
                  ),
                  title: Text(chat.otherUserName),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        dateFormat.format(chat.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.chatThread,
                      arguments: {
                        'chatId': chat.id,
                        'otherUserId': chat.otherUserId,
                        'otherUserName': chat.otherUserName,
                        'otherUserPhotoUrl': chat.otherUserPhotoUrl,
                      },
                    );
                  },
                )),
          ],
          if (friends.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Friends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...friends.map((chat) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat.otherUserPhotoUrl),
                  ),
                  title: Text(chat.otherUserName),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    dateFormat.format(chat.lastMessageTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.chatThread,
                      arguments: {
                        'chatId': chat.id,
                        'otherUserId': chat.otherUserId,
                        'otherUserName': chat.otherUserName,
                        'otherUserPhotoUrl': chat.otherUserPhotoUrl,
                      },
                    );
                  },
                )),
          ],
          if (agencies.isEmpty && friends.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No messages yet'),
              ),
            ),
        ],
      ),
    );
  }
}
