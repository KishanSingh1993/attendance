import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../view_models/history_track_view_model.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  final int userId;
  final int attendanceId;

  const AttendanceDetailsScreen({
    Key? key,
    required this.userId,
    required this.attendanceId,
  }) : super(key: key);

  @override
  _AttendanceDetailsScreenState createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LatLng _initialPosition = const LatLng(28.7041, 77.1025);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => fetchAttendanceHistory());
  }

  void fetchAttendanceHistory() async {
    final viewModel = Provider.of<AttendanceHistoryViewModel>(
        context, listen: false);
    await viewModel.fetchHistory(widget.userId, widget.attendanceId);

    final history = viewModel.attendanceHistory;
    if (history.isNotEmpty) {
      setState(() {
        _initialPosition = LatLng(
          double.parse(history.first.locationLatitude),
          double.parse(history.first.locationLongitude),
        );

        _markers.addAll(history.map((entry) {
          final position = LatLng(
            double.parse(entry.locationLatitude),
            double.parse(entry.locationLongitude),
          );
          return Marker(
            markerId: MarkerId(entry.employeeIdTrackingId),
            position: position,
            infoWindow: InfoWindow(
              title: entry.locationArea,
              snippet:
              'Time: ${entry.dataEntryDate.hour}:${entry.dataEntryDate.minute}',
            ),
          );
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Check In: ${DateTime.now().toLocal().toString().split(' ')[0]}'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Consumer<AttendanceHistoryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14,
                  ),
                  markers: _markers,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.attendanceHistory.length,
                  itemBuilder: (context, index) {
                    final entry = viewModel.attendanceHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(entry.locationArea),
                      subtitle: Text(
                          'Time: ${entry.dataEntryDate.hour}:${entry.dataEntryDate.minute}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
