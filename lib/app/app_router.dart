import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/main_shell_screen.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/trips_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/agency_profile_screen.dart';
import '../screens/trip_detail_screen.dart';
import '../screens/chat_inbox_screen.dart';
import '../screens/chat_thread_screen.dart';
import '../screens/booking_summary_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/kyc_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String profileSetup = '/profileSetup';
  static const String main = '/main';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String trips = '/trips';
  static const String profile = '/profile';
  static const String userProfile = '/userProfile';
  static const String agencyProfile = '/agencyProfile';
  static const String tripDetail = '/tripDetail';
  static const String chatInbox = '/chatInbox';
  static const String chatThread = '/chatThread';
  static const String bookingSummary = '/bookingSummary';
  static const String payment = '/payment';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String kyc = '/kyc';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case otp:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OTPScreen(mobileNumber: args?['mobileNumber'] ?? ''),
        );
      case profileSetup:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainShellScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case explore:
        return MaterialPageRoute(builder: (_) => const ExploreScreen());
      case trips:
        return MaterialPageRoute(builder: (_) => const TripsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case userProfile:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => UserProfileScreen(userId: args?['userId'] ?? ''),
        );
      case agencyProfile:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AgencyProfileScreen(agencyId: args?['agencyId'] ?? ''),
        );
      case tripDetail:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TripDetailScreen(tripId: args?['tripId'] ?? ''),
        );
      case chatInbox:
        return MaterialPageRoute(builder: (_) => const ChatInboxScreen());
      case chatThread:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatThreadScreen(
            chatId: args?['chatId'] ?? '',
            otherUserId: args?['otherUserId'] ?? '',
            otherUserName: args?['otherUserName'] ?? '',
            otherUserPhotoUrl: args?['otherUserPhotoUrl'] ?? '',
          ),
        );
      case bookingSummary:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BookingSummaryScreen(tripId: args?['tripId'] ?? ''),
        );
      case payment:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(tripId: args?['tripId'] ?? ''),
        );
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case kyc:
        return MaterialPageRoute(builder: (_) => const KYCScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${routeSettings.name} not found'),
            ),
          ),
        );
    }
  }
}
