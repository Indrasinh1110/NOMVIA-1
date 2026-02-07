import '../enums/booking_state.dart';

class Trip {
  final String id;
  final String agencyId;
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  final double price;
  final int totalSeats;
  final int availableSeats;
  final List<String> imageUrls;
  final String description;
  final List<String> itinerary;
  final List<String> passengerIds;
  final Map<String, BookingState> userBookingStates;
  int likes;
  final List<String> likedUserIds;
  final String refundRules;

  Trip({
    required this.id,
    required this.agencyId,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    required this.imageUrls,
    required this.description,
    required this.itinerary,
    required this.passengerIds,
    required this.userBookingStates,
    required this.likes,
    required this.likedUserIds,
    required this.refundRules,
  });

  bool get isCompleted => endDate.isBefore(DateTime.now());
  bool get isUpcoming => startDate.isAfter(DateTime.now());
}
