import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app/app_router.dart';
import '../state/app_state.dart';
import '../enums/booking_state.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with SingleTickerProviderStateMixin {
  final appState = AppState.instance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<dynamic> _getTripsForTab(int index) {
    if (appState.currentUser == null) return [];

    switch (index) {
      case 0: // Upcoming
        return appState.allTrips.where((trip) {
          final state = trip.userBookingStates[appState.currentUser!.id] ??
              BookingState.none;
          return (state == BookingState.confirmed ||
                  state == BookingState.onHold) &&
              trip.isUpcoming;
        }).toList();
      case 1: // Completed
        return appState.allTrips.where((trip) {
          final state = trip.userBookingStates[appState.currentUser!.id] ??
              BookingState.none;
          return state == BookingState.completed || trip.isCompleted;
        }).toList();
      case 2: // Interested
        return appState.allTrips.where((trip) {
          final state = trip.userBookingStates[appState.currentUser!.id] ??
              BookingState.none;
          return state == BookingState.interested;
        }).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Interested'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [0, 1, 2].map((index) {
          final trips = _getTripsForTab(index);
          if (trips.isEmpty) {
            return const Center(
              child: Text('No trips found'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (context, i) {
              final trip = trips[i] as dynamic;
              final dateFormat = DateFormat('MMM dd, yyyy');
              final agency = appState.agencies.firstWhere(
                (a) => a.id == trip.agencyId,
                orElse: () => appState.agencies.first,
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.tripDetail,
                      arguments: {'tripId': trip.id},
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            trip.imageUrls.first,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trip.location,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(agency.logoUrl),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    agency.name,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
