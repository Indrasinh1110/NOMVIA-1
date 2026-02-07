import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../enums/follow_state.dart';
import '../models/agency.dart';
import '../widgets/trip_card.dart';

class AgencyProfileScreen extends StatefulWidget {
  final String agencyId;

  const AgencyProfileScreen({super.key, required this.agencyId});

  @override
  State<AgencyProfileScreen> createState() => _AgencyProfileScreenState();
}

class _AgencyProfileScreenState extends State<AgencyProfileScreen> {
  final appState = AppState.instance;

  Agency? get agency {
    try {
      return appState.agencies.firstWhere((a) => a.id == widget.agencyId);
    } catch (e) {
      return null;
    }
  }

  bool get isFollowing {
    if (appState.currentUser == null || agency == null) return false;
    return agency!.followerStates[appState.currentUser!.id] ==
        FollowState.following;
  }

  void _toggleFollow() {
    setState(() {
      appState.toggleFollow(widget.agencyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAgency = agency;
    if (profileAgency == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agency Profile')),
        body: const Center(child: Text('Agency not found')),
      );
    }

    final upcomingTrips = appState.allTrips
        .where((trip) =>
            trip.agencyId == widget.agencyId && trip.isUpcoming)
        .toList();
    final pastTrips = appState.allTrips
        .where((trip) =>
            trip.agencyId == widget.agencyId && trip.isCompleted)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agency Profile'),
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
                    backgroundImage: NetworkImage(profileAgency.logoUrl),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profileAgency.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (profileAgency.isVerified) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.verified, color: Colors.blue),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        profileAgency.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profileAgency.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    profileAgency.yearsActive.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Years Active'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    profileAgency.tripsCompleted.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Trips Completed'),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 20, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        profileAgency.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text('Rating'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _toggleFollow,
                    icon: Icon(isFollowing ? Icons.check : Icons.add),
                    label: Text(isFollowing ? 'Following' : 'Follow'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Trips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (upcomingTrips.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No upcoming trips'),
                      ),
                    )
                  else
                    ...upcomingTrips.map((trip) => TripCard(trip: trip)),
                  const SizedBox(height: 24),
                  const Text(
                    'Past Trips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (pastTrips.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No past trips'),
                      ),
                    )
                  else
                    ...pastTrips.map((trip) => TripCard(trip: trip)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
