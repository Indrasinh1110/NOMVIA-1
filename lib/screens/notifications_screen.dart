import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final appState = AppState.instance;
  final _notifications = <NotificationModel>[];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    _notifications.addAll([
      NotificationModel(
        id: '1',
        type: 'booking',
        title: 'Booking Confirmed',
        message: 'Your booking for Himalayan Trek Adventure has been confirmed!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        relatedId: 'trip1',
      ),
      NotificationModel(
        id: '2',
        type: 'friend',
        title: 'Friend Request',
        message: 'Sarah Smith sent you a friend request',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        relatedId: 'user2',
      ),
      NotificationModel(
        id: '3',
        type: 'trip',
        title: 'New Trip Available',
        message: 'Mountain Adventures added a new trip: Spiti Valley Expedition',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        relatedId: 'trip3',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification.isRead = true;
                }
              });
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text('No notifications'),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                IconData icon;
                Color iconColor;

                switch (notification.type) {
                  case 'booking':
                    icon = Icons.check_circle;
                    iconColor = Colors.green;
                    break;
                  case 'friend':
                    icon = Icons.person_add;
                    iconColor = Colors.blue;
                    break;
                  case 'trip':
                    icon = Icons.flight;
                    iconColor = Colors.orange;
                    break;
                  default:
                    icon = Icons.notifications;
                    iconColor = Colors.grey;
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: iconColor.withValues(alpha: 0.1),
                    child: Icon(icon, color: iconColor),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight:
                          notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message),
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: notification.isRead
                      ? null
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                  onTap: () {
                    setState(() {
                      notification.isRead = true;
                    });
                  },
                );
              },
            ),
    );
  }
}
