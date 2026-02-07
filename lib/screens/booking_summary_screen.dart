import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app/app_router.dart';
import '../state/app_state.dart';
import '../models/trip.dart';
import '../models/agency.dart';

class BookingSummaryScreen extends StatefulWidget {
  final String tripId;

  const BookingSummaryScreen({super.key, required this.tripId});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final appState = AppState.instance;

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

  void _confirmBooking() {
    if (trip == null || appState.currentUser == null) return;

    Navigator.of(context).pushNamed(
      AppRouter.payment,
      arguments: {'tripId': widget.tripId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripData = trip;
    final agencyData = agency;
    if (tripData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Summary')),
        body: const Center(child: Text('Trip not found')),
      );
    }

    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripData.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tripData.location,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${dateFormat.format(tripData.startDate)} - ${dateFormat.format(tripData.endDate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duration: ${tripData.duration} days',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (agencyData != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(agencyData.logoUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agencyData.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trip Price',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '₹${tripData.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Taxes & Fees',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '₹${(tripData.price * 0.18).toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${(tripData.price * 1.18).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Confirm & Proceed to Payment',
                    style: TextStyle(fontSize: 16),
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
