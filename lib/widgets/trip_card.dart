import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../models/agency.dart';
import '../state/app_state.dart';
import '../app/app_router.dart';
import '../enums/booking_state.dart';
import 'package:share_plus/share_plus.dart';

class TripCard extends StatefulWidget {
  final Trip trip;
  final Agency? agency;

  const TripCard({
    super.key,
    required this.trip,
    this.agency,
  });

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  final appState = AppState.instance;
  bool _isWishlisted = false;

  Agency get agency {
    if (widget.agency != null) return widget.agency!;
    return appState.agencies.firstWhere(
      (a) => a.id == widget.trip.agencyId,
      orElse: () => appState.agencies.first,
    );
  }

  bool get isLiked {
    if (appState.currentUser == null) return false;
    return widget.trip.likedUserIds.contains(appState.currentUser!.id);
  }

  BookingState get bookingState {
    if (appState.currentUser == null) return BookingState.none;
    return widget.trip.userBookingStates[appState.currentUser!.id] ??
        BookingState.none;
  }

  void _handleLike() {
    setState(() {
      appState.toggleLike(widget.trip.id);
    });
  }

  void _handleShare() {
    Share.share('Check out this trip: ${widget.trip.title}');
  }

  void _handleBookNow() {
    if (appState.currentUser == null) return;
    if (!appState.isKycCompleted) {
      Navigator.of(context).pushNamed(AppRouter.kyc);
      return;
    }
    Navigator.of(context).pushNamed(
      AppRouter.bookingSummary,
      arguments: {'tripId': widget.trip.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final agencyData = agency;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.tripDetail,
            arguments: {'tripId': widget.trip.id},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    widget.trip.imageUrls.first,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                        ),
                        onPressed: _handleLike,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: _handleShare,
                      ),
                      IconButton(
                        icon: Icon(
                          _isWishlisted
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: _isWishlisted ? Colors.amber : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isWishlisted = !_isWishlisted;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trip.location,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${dateFormat.format(widget.trip.startDate)} - ${dateFormat.format(widget.trip.endDate)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.trip.duration} days',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${widget.trip.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      Text(
                        '${widget.trip.availableSeats} seats left',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRouter.agencyProfile,
                        arguments: {'agencyId': agencyData!.id},
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(agencyData.logoUrl),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          agencyData.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (agencyData.isVerified) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified, size: 16, color: Colors.blue),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (appState.currentUser != null &&
                      appState.currentUser!.friendIds.isNotEmpty)
                    Row(
                      children: [
                        const Text(
                          'Mutual friends: ',
                          style: TextStyle(fontSize: 12),
                        ),
                        ...appState.currentUser!.friendIds
                            .take(3)
                            .map((friendId) {
                          final friend = appState.users.firstWhere(
                            (u) => u.id == friendId,
                            orElse: () => appState.users.first,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(friend.photoUrl),
                            ),
                          );
                        }),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: bookingState == BookingState.confirmed
                          ? null
                          : _handleBookNow,
                      child: Text(
                        bookingState == BookingState.confirmed
                            ? 'Booked'
                            : bookingState == BookingState.interested
                                ? 'Interested'
                                : 'Book Now',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
