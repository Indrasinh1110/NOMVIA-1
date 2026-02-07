class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String? relatedId;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    this.relatedId,
  });
}
