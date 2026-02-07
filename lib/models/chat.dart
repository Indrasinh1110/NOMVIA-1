class Chat {
  final String id;
  final String type; // 'agency' or 'friend'
  final String otherUserId;
  final String otherUserName;
  final String otherUserPhotoUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  Chat({
    required this.id,
    required this.type,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPhotoUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String senderPhotoUrl;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.message,
    required this.timestamp,
  });
}
