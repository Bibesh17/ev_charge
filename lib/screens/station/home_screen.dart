import 'package:ev_charge/models/reservation.model.dart';
import 'package:ev_charge/services/reservation/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StationHomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  const StationHomeScreen({super.key});

  @override
  State<StationHomeScreen> createState() => _StationHomeScreenState();
}

class _StationHomeScreenState extends State<StationHomeScreen> {
  bool _isLoading = true;
  String? _error;

  final ReservationService reservationService = ReservationService();
  List<Reservation> _reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchReservations,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchReservations,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $_error',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchReservations,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _reservations.isEmpty
                    ? const Center(
                        child: Text('No upcoming reservations'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = _reservations[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Booking #${reservation.id}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        reservation.startingTime,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.access_time,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        reservation.endingTime,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.person,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        reservation.reservedBy,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // Navigate to booking details
                                        },
                                        child: const Text('View Details'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Future<void> _fetchReservations() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final bookings = await reservationService.getReservations();
      print(bookings);
      if (mounted) {
        setState(() {
          _reservations = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }
}
