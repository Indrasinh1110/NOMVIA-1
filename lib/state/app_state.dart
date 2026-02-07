import '../enums/auth_state.dart';
import '../enums/booking_state.dart';
import '../enums/friend_state.dart';
import '../enums/follow_state.dart';
import '../enums/privacy_mode.dart';
import '../models/agency.dart';
import '../models/trip.dart';
import '../models/user.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  static AppState get instance => _instance;
  factory AppState() => _instance;
  AppState._internal();

  AuthState authState = AuthState.loggedOut;
  bool isKycCompleted = false;
  PrivacyMode privacyMode = PrivacyMode.off;
  List<Trip> allTrips = [];
  List<Agency> agencies = [];
  List<User> users = [];
  User? currentUser;

  void initializeMockData() {
    // Create agencies
    agencies = [
      Agency(
        id: 'agency1',
        name: 'Mountain Adventures',
        logoUrl: 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=200',
        location: 'Himalayas, India',
        description: 'Leading adventure travel agency specializing in mountain treks and expeditions.',
        isVerified: true,
        yearsActive: 8,
        tripsCompleted: 245,
        rating: 4.8,
        tripIds: ['trip1', 'trip2', 'trip3'],
        followerStates: {},
      ),
      Agency(
        id: 'agency2',
        name: 'Coastal Escapes',
        logoUrl: 'https://images.unsplash.com/photo-1507525421304-677d55e20b4f?w=200',
        location: 'Goa, India',
        description: 'Your gateway to beautiful coastal destinations and beach getaways.',
        isVerified: true,
        yearsActive: 5,
        tripsCompleted: 180,
        rating: 4.6,
        tripIds: ['trip4', 'trip5'],
        followerStates: {},
      ),
      Agency(
        id: 'agency3',
        name: 'Desert Trails',
        logoUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=200',
        location: 'Rajasthan, India',
        description: 'Experience the magic of desert landscapes and cultural heritage.',
        isVerified: false,
        yearsActive: 3,
        tripsCompleted: 92,
        rating: 4.4,
        tripIds: ['trip6'],
        followerStates: {},
      ),
    ];

    // Create users
    users = [
      User(
        id: 'user1',
        username: 'traveler_john',
        name: 'John Doe',
        bio: 'Passionate traveler exploring the world one trip at a time',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        mobileNumber: '+919876543210',
        travellerType: 'Adventure Seeker',
        friendCount: 12,
        privacyMode: PrivacyMode.off,
        friendIds: ['user2', 'user3'],
        friendStates: {
          'user2': FriendState.accepted,
          'user3': FriendState.accepted,
        },
        completedTripIds: ['trip1'],
        isKycCompleted: true,
      ),
      User(
        id: 'user2',
        username: 'wanderlust_sarah',
        name: 'Sarah Smith',
        bio: 'Love hiking and photography',
        photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
        mobileNumber: '+919876543211',
        travellerType: 'Nature Lover',
        friendCount: 8,
        privacyMode: PrivacyMode.off,
        friendIds: ['user1'],
        friendStates: {
          'user1': FriendState.accepted,
        },
        completedTripIds: [],
        isKycCompleted: true,
      ),
      User(
        id: 'user3',
        username: 'explorer_mike',
        name: 'Mike Johnson',
        bio: 'Always ready for the next adventure',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
        mobileNumber: '+919876543212',
        travellerType: 'Backpacker',
        friendCount: 15,
        privacyMode: PrivacyMode.off,
        friendIds: ['user1'],
        friendStates: {
          'user1': FriendState.accepted,
        },
        completedTripIds: ['trip2'],
        isKycCompleted: false,
      ),
    ];

    // Create trips
    final now = DateTime.now();
    allTrips = [
      Trip(
        id: 'trip1',
        agencyId: 'agency1',
        title: 'Himalayan Trek Adventure',
        location: 'Manali, Himachal Pradesh',
        startDate: now.add(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 20)),
        duration: 5,
        price: 15000,
        totalSeats: 20,
        availableSeats: 12,
        imageUrls: [
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        ],
        description: 'Experience the breathtaking beauty of the Himalayas with this 5-day trek.',
        itinerary: [
          'Day 1: Arrival and acclimatization',
          'Day 2: Trek to base camp',
          'Day 3: Summit attempt',
          'Day 4: Return journey',
          'Day 5: Departure',
        ],
        passengerIds: ['user1'],
        userBookingStates: {
          'user1': BookingState.confirmed,
        },
        likes: 45,
        likedUserIds: ['user2', 'user3'],
        refundRules: 'Full refund if cancelled 7 days before trip. 50% refund if cancelled 3 days before.',
      ),
      Trip(
        id: 'trip2',
        agencyId: 'agency1',
        title: 'Valley of Flowers',
        location: 'Uttarakhand',
        startDate: now.add(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 35)),
        duration: 5,
        price: 12000,
        totalSeats: 15,
        availableSeats: 8,
        imageUrls: [
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
        ],
        description: 'Witness the stunning Valley of Flowers in full bloom.',
        itinerary: [
          'Day 1: Arrival',
          'Day 2-4: Valley exploration',
          'Day 5: Departure',
        ],
        passengerIds: ['user3'],
        userBookingStates: {
          'user3': BookingState.completed,
        },
        likes: 32,
        likedUserIds: ['user1'],
        refundRules: 'Full refund if cancelled 10 days before trip.',
      ),
      Trip(
        id: 'trip3',
        agencyId: 'agency1',
        title: 'Spiti Valley Expedition',
        location: 'Spiti, Himachal Pradesh',
        startDate: now.add(const Duration(days: 45)),
        endDate: now.add(const Duration(days: 52)),
        duration: 7,
        price: 25000,
        totalSeats: 12,
        availableSeats: 5,
        imageUrls: [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        ],
        description: 'Explore the remote and beautiful Spiti Valley.',
        itinerary: [
          'Day 1: Arrival in Manali',
          'Day 2-6: Spiti exploration',
          'Day 7: Return',
        ],
        passengerIds: [],
        userBookingStates: {},
        likes: 28,
        likedUserIds: [],
        refundRules: 'Full refund if cancelled 14 days before trip.',
      ),
      Trip(
        id: 'trip4',
        agencyId: 'agency2',
        title: 'Goa Beach Paradise',
        location: 'Goa',
        startDate: now.add(const Duration(days: 20)),
        endDate: now.add(const Duration(days: 23)),
        duration: 3,
        price: 8000,
        totalSeats: 25,
        availableSeats: 18,
        imageUrls: [
          'https://images.unsplash.com/photo-1507525421304-677d55e20b4f?w=800',
        ],
        description: 'Relax and unwind on the beautiful beaches of Goa.',
        itinerary: [
          'Day 1: Beach hopping',
          'Day 2: Water sports',
          'Day 3: Departure',
        ],
        passengerIds: [],
        userBookingStates: {},
        likes: 56,
        likedUserIds: ['user1', 'user2'],
        refundRules: 'Full refund if cancelled 5 days before trip.',
      ),
      Trip(
        id: 'trip5',
        agencyId: 'agency2',
        title: 'Andaman Islands',
        location: 'Andaman & Nicobar',
        startDate: now.add(const Duration(days: 60)),
        endDate: now.add(const Duration(days: 67)),
        duration: 7,
        price: 35000,
        totalSeats: 18,
        availableSeats: 10,
        imageUrls: [
          'https://images.unsplash.com/photo-1507525421304-677d55e20b4f?w=800',
        ],
        description: 'Discover the pristine beaches and marine life of Andaman.',
        itinerary: [
          'Day 1: Arrival',
          'Day 2-6: Island hopping and activities',
          'Day 7: Departure',
        ],
        passengerIds: [],
        userBookingStates: {},
        likes: 41,
        likedUserIds: [],
        refundRules: 'Full refund if cancelled 15 days before trip.',
      ),
      Trip(
        id: 'trip6',
        agencyId: 'agency3',
        title: 'Rajasthan Desert Safari',
        location: 'Jaisalmer, Rajasthan',
        startDate: now.add(const Duration(days: 25)),
        endDate: now.add(const Duration(days: 28)),
        duration: 3,
        price: 10000,
        totalSeats: 20,
        availableSeats: 15,
        imageUrls: [
          'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800',
        ],
        description: 'Experience the golden sands and rich culture of Rajasthan.',
        itinerary: [
          'Day 1: Desert camp',
          'Day 2: Camel safari',
          'Day 3: Departure',
        ],
        passengerIds: [],
        userBookingStates: {},
        likes: 38,
        likedUserIds: [],
        refundRules: 'Full refund if cancelled 7 days before trip.',
      ),
    ];

    // Set current user (will be set after login)
    currentUser = null;
  }

  void setCurrentUser(User user) {
    currentUser = user;
    authState = AuthState.loggedIn;
    isKycCompleted = user.isKycCompleted;
    privacyMode = user.privacyMode;
  }

  void updatePrivacyMode(PrivacyMode mode) {
    privacyMode = mode;
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(privacyMode: mode);
    }
  }

  void updateBookingState(String tripId, BookingState state) {
    final trip = allTrips.firstWhere((t) => t.id == tripId);
    if (currentUser != null) {
      trip.userBookingStates[currentUser!.id] = state;
    }
  }

  void toggleLike(String tripId) {
    final trip = allTrips.firstWhere((t) => t.id == tripId);
    if (currentUser != null) {
      if (trip.likedUserIds.contains(currentUser!.id)) {
        trip.likedUserIds.remove(currentUser!.id);
        trip.likes--;
      } else {
        trip.likedUserIds.add(currentUser!.id);
        trip.likes++;
      }
    }
  }

  void toggleFollow(String agencyId) {
    final agency = agencies.firstWhere((a) => a.id == agencyId);
    if (currentUser != null) {
      final currentState = agency.followerStates[currentUser!.id] ?? FollowState.notFollowing;
      agency.followerStates[currentUser!.id] = currentState == FollowState.following
          ? FollowState.notFollowing
          : FollowState.following;
    }
  }
}
