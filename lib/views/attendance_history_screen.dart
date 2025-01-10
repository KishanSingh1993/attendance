import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/attendance_view_model.dart';
import 'attendance_details_screen.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  @override
  _AttendanceHistoryScreenState createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  late Future<void> _attendanceFuture;

  // Dropdown state for selected month
  String _selectedMonth = 'January'; // Default selected month

  @override
  void initState() {
    super.initState();
    final attendanceViewModel =
        Provider.of<AttendanceViewModel>(context, listen: false);
    _attendanceFuture = attendanceViewModel.fetchAttendanceHistory(4);
  }

  @override
  Widget build(BuildContext context) {
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Column(
        children: [
          // Dropdown with calendar icon inside a container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.blueGrey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blue),
                    const SizedBox(width: 10),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMonth,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.blue),
                        items: [
                          'January',
                          'February',
                          'March',
                          'April',
                          'May',
                          'June',
                          'July',
                          'August',
                          'September',
                          'October',
                          'November',
                          'December'
                        ].map((month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(
                              month,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMonth = value!;
                          });

                          // Optional: Refresh data based on the selected month
                          // attendanceViewModel.fetchAttendanceHistory(monthIndex);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Attendance list below the dropdown
          Expanded(
            child: FutureBuilder(
              future: _attendanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError ||
                    attendanceViewModel.attendanceHistory == null) {
                  return const Center(child: Text('Error loading data'));
                } else {
                  return ListView.builder(
                    itemCount:
                        attendanceViewModel.attendanceHistory?.length ?? 0,
                    itemBuilder: (context, index) {
                      final attendance =
                          attendanceViewModel.attendanceHistory![index];
                      return AttendanceCard(attendance: attendance);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final dynamic attendance;

  const AttendanceCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final checkIn = attendance['checkIn'] ?? 'N/A';
    final checkOut = attendance['checkOut'] ?? 'N/A';
    final duration = attendance['duration'] ?? 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(checkOut),
          child: Text(
            checkIn.split('-').first, // Display the day (e.g., 06)
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(checkIn),
        subtitle: Text(
          'Duration: $duration hrs\nStatus: ${checkOut == "Running" ? "Not Checked Out" : "Completed"}',
          style: const TextStyle(fontSize: 13),
        ),
        trailing: const Icon(Icons.map, color: Colors.blue),
        onTap: () {
          // Navigate to details
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const AttendanceDetailsScreen(
                    userId: 9, attendanceId: 188)),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == "Running") return Colors.orange;
    return Colors.green;
  }
}
