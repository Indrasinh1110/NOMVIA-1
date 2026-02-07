import 'dart:async';
import 'package:flutter/material.dart';
import '../app/app_router.dart';
import '../state/app_state.dart';
import '../enums/booking_state.dart';
import '../models/trip.dart';

class PaymentScreen extends StatefulWidget {
  final String tripId;

  const PaymentScreen({super.key, required this.tripId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final appState = AppState.instance;
  bool _paymentCompleted = false;

  Trip? get trip {
    try {
      return appState.allTrips.firstWhere((t) => t.id == widget.tripId);
    } catch (e) {
      return null;
    }
  }

  void _simulatePayment() {
    setState(() {
      _paymentCompleted = true;
    });

    if (appState.currentUser != null && trip != null) {
      appState.updateBookingState(widget.tripId, BookingState.onHold);
    }

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      if (appState.currentUser != null && trip != null) {
        appState.updateBookingState(widget.tripId, BookingState.confirmed);
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed(AppRouter.main);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking confirmed!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripData = trip;
    if (tripData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: const Center(child: Text('Trip not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_paymentCompleted) ...[
              const Text(
                'Scan QR Code to Pay',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code,
                          size: 200,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Amount: ₹${(tripData.price * 1.18).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'UPI ID: nomvia@paytm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _simulatePayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Simulate Payment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ] else ...[
              const Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your booking is being confirmed...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
