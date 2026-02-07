import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/trip_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final appState = AppState.instance;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTrips = appState.allTrips.where((trip) {
      if (_searchQuery.isEmpty) return true;
      return trip.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          trip.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search trips...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Price: Low to High'),
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            label: const Text('Price: High to Low'),
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            label: const Text('Duration: Short'),
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            label: const Text('Duration: Long'),
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            label: const Text('Verified Only'),
                            onSelected: (_) {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Apply Filters'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: filteredTrips.isEmpty
          ? const Center(
              child: Text('No trips found'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                return TripCard(trip: filteredTrips[index]);
              },
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
