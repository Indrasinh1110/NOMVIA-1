import '../enums/follow_state.dart';

class Agency {
  final String id;
  final String name;
  final String logoUrl;
  final String location;
  final String description;
  final bool isVerified;
  final int yearsActive;
  final int tripsCompleted;
  final double rating;
  final List<String> tripIds;
  final Map<String, FollowState> followerStates;

  Agency({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.location,
    required this.description,
    required this.isVerified,
    required this.yearsActive,
    required this.tripsCompleted,
    required this.rating,
    required this.tripIds,
    required this.followerStates,
  });
}
