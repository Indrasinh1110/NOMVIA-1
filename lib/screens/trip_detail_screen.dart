import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app/app_router.dart';
import '../state/app_state.dart';
import '../enums/booking_state.dart';
import '../models/trip.dart';
import '../models/agency.dart';
import 'package:share_plus/share_plus.dart';

class TripDetailScreen extends StatefulWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final appState = AppState.instance;
  // int _currentImageIndex = 0; // Unused

  Trip? get trip {
    try {
      return appState.allTrips.firstWhere((t) => t.id == widget.tripId);
    } catch (e) {
      return null;
    }
  }

  Agency? get agency {
    if (trip == null) return null;
    try {
      return appState.agencies.firstWhere((a) => a.id == trip!.agencyId);
    } catch (e) {
      return null;
    }
  }

  bool get isLiked {
    if (appState.currentUser == null || trip == null) return false;
    return trip!.likedUserIds.contains(appState.currentUser!.id);
  }

  BookingState get bookingState {
    if (appState.currentUser == null || trip == null) return BookingState.none;
    return trip!.userBookingStates[appState.currentUser!.id] ??
        BookingState.none;
  }

  void _handleLike() {
    setState(() {
      appState.toggleLike(widget.tripId);
    });
  }

  void _handleBookNow() {
    if (appState.currentUser == null) return;
    if (!appState.isKycCompleted) {
      Navigator.of(context).pushNamed(AppRouter.kyc);
      return;
    }
    Navigator.of(context).pushNamed(
      AppRouter.bookingSummary,
      arguments: {'tripId': widget.tripId},
    );
  }

  void _handleAskQuestion() {
    if (agency == null) return;
    Navigator.of(context).pushNamed(
      AppRouter.chatThread,
      arguments: {
        'chatId': 'chat_${appState.currentUser!.id}_${agency!.id}',
        'otherUserId': agency!.id,
        'otherUserName': agency!.name,
        'otherUserPhotoUrl': agency!.logoUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripData = trip;
    final agencyData = agency;
    if (tripData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: const Center(child: Text('Trip not found')),
      );
    }

    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: tripData.imageUrls.length,
                onPageChanged: (index) {
                  // setState(() {
                  //   _currentImageIndex = index;
                  // });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    tripData.imageUrls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                color: isLiked ? Colors.red : Colors.white,
                onPressed: _handleLike,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                color: Colors.white,
                onPressed: () {
                  Share.share('Check out this trip: ${tripData.title}');
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tripData.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        tripData.location,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                                  Icon(Icons.calendar_today, color: Colors.blue),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateFormat.format(tripData.startDate),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Start', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.access_time, color: Colors.blue),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${tripData.duration} days',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Duration', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.people, color: Colors.blue),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${tripData.availableSeats}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Seats Left', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '₹${tripData.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (agencyData != null)
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.agencyProfile,
                            arguments: {'agencyId': agencyData.id},
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(agencyData.logoUrl),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          agencyData.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (agencyData.isVerified) ...[
                                          const SizedBox(width: 8),
                                          Icon(Icons.verified, size: 20, color: Colors.blue),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      agencyData.location,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tripData.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Itinerary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...tripData.itinerary.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, size: 20, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),
                  if (tripData.passengerIds.isNotEmpty) ...[
                    const Text(
                      'Passengers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: tripData.passengerIds.map((userId) {
                        final user = appState.users.firstWhere(
                          (u) => u.id == userId,
                          orElse: () => appState.users.first,
                        );
                        return CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    'Refund Rules',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        tripData.refundRules,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
              child: OutlinedButton.icon(
                onPressed: _handleAskQuestion,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Ask Question'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: bookingState == BookingState.confirmed
                    ? null
                    : _handleBookNow,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    bookingState == BookingState.confirmed
                        ? 'Booked'
                        : 'Book Now',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
