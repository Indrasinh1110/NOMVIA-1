import '../enums/friend_state.dart';
import '../enums/privacy_mode.dart';

class User {
  final String id;
  final String username;
  final String name;
  final String bio;
  final String photoUrl;
  final String mobileNumber;
  final String travellerType;
  final int friendCount;
  final PrivacyMode privacyMode;
  final List<String> friendIds;
  final Map<String, FriendState> friendStates;
  final List<String> completedTripIds;
  final bool isKycCompleted;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.bio,
    required this.photoUrl,
    required this.mobileNumber,
    required this.travellerType,
    required this.friendCount,
    required this.privacyMode,
    required this.friendIds,
    required this.friendStates,
    required this.completedTripIds,
    required this.isKycCompleted,
  });

  User copyWith({
    String? id,
    String? username,
    String? name,
    String? bio,
    String? photoUrl,
    String? mobileNumber,
    String? travellerType,
    int? friendCount,
    PrivacyMode? privacyMode,
    List<String>? friendIds,
    Map<String, FriendState>? friendStates,
    List<String>? completedTripIds,
    bool? isKycCompleted,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      travellerType: travellerType ?? this.travellerType,
      friendCount: friendCount ?? this.friendCount,
      privacyMode: privacyMode ?? this.privacyMode,
      friendIds: friendIds ?? this.friendIds,
      friendStates: friendStates ?? this.friendStates,
      completedTripIds: completedTripIds ?? this.completedTripIds,
      isKycCompleted: isKycCompleted ?? this.isKycCompleted,
    );
  }
}
