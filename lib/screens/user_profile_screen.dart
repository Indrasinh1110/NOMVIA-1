import 'package:flutter/material.dart';
import '../app/app_router.dart';
import '../state/app_state.dart';
import '../enums/friend_state.dart';
import '../models/user.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final appState = AppState.instance;

  User? get user {
    try {
      return appState.users.firstWhere((u) => u.id == widget.userId);
    } catch (e) {
      return null;
    }
  }

  FriendState get friendState {
    if (appState.currentUser == null || user == null) {
      return FriendState.none;
    }
    return appState.currentUser!.friendStates[widget.userId] ??
        FriendState.none;
  }

  void _handleFriendRequest() {
    if (appState.currentUser == null || user == null) return;

    setState(() {
      final currentState = friendState;
      if (currentState == FriendState.none) {
        appState.currentUser!.friendStates[widget.userId] = FriendState.pending;
      }
    });
  }

  void _handleChat() {
    if (friendState != FriendState.accepted) return;

    Navigator.of(context).pushNamed(
      AppRouter.chatThread,
      arguments: {
        'chatId': 'chat_${appState.currentUser!.id}_${widget.userId}',
        'otherUserId': widget.userId,
        'otherUserName': user!.name,
        'otherUserPhotoUrl': user!.photoUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileUser = user;
    if (profileUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Profile')),
        body: const Center(child: Text('User not found')),
      );
    }

  final isOwnProfile = appState.currentUser?.id == widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileUser.photoUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profileUser.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profileUser.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profileUser.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            profileUser.friendCount.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Friends'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Chip(
                    label: Text(profileUser.travellerType),
                    backgroundColor: Colors.blue[50],
                  ),
                  if (!isOwnProfile) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (friendState == FriendState.none)
                          ElevatedButton(
                            onPressed: _handleFriendRequest,
                            child: const Text('Send Friend Request'),
                          )
                        else if (friendState == FriendState.pending)
                          OutlinedButton(
                            onPressed: null,
                            child: const Text('Request Pending'),
                          )
                        else if (friendState == FriendState.accepted) ...[
                          ElevatedButton.icon(
                            onPressed: _handleChat,
                            icon: const Icon(Icons.chat),
                            label: const Text('Chat'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: null,
                            child: const Text('Friends'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
