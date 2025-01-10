import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // For location services
import 'package:shared_preferences/shared_preferences.dart';
import 'attendance_history_screen.dart';
import '../view_models/checkin_view_model.dart';
import 'login_screen.dart';
import 'package:geocoding/geocoding.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _location = 'Fetching Address';
  String cTime = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Logout functionality
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear the session data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  // Fetch the current location
  Future<void> _getCurrentLocation() async {
    try {
      // Check for location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _location = 'Location permissions are denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _location = 'Location permissions are permanently denied.';
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update the location string
      setState(() {
        _location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        _location = 'Failed to fetch location.';
      });
    }
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     // Check for location permissions
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       setState(() {
  //         _location = 'Location services are disabled.';
  //       });
  //       return;
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         setState(() {
  //           _location = 'Location permissions are denied.';
  //         });
  //         return;
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       setState(() {
  //         _location = 'Location permissions are permanently denied.';
  //       });
  //       return;
  //     }

  //     // Get the current position
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     // Fetch the address based on latitude and longitude
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     // Get the first placemark (most relevant)
  //     Placemark place = placemarks[0];
  //     String address =
  //         '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';

  //     // Update the location string with the address
  //     setState(() {
  //       _location = address; // Display the address instead of coordinates
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _location = 'Failed to fetch location';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Get current date and time
    String formattedDate =
        DateFormat('EEEE, MMM dd, yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification click
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context), // Calls the logout function
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Card
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to MIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Dynamic Time
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Dynamic Date
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                formattedDate,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Location: $_location', // Dynamic location
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.login, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Check-in: $cTime',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.blue),
                        ),
                        const SizedBox(height: 8),
                        Consumer<CheckInViewModel>(
                          builder: (context, checkInViewModel, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Check-In Switch
                                if (!checkInViewModel.isCheckedIn)
                                  Switch(
                                    value: false,
                                    onChanged: (value) async {
                                      if (value) {
                                        checkInViewModel.setLoading(true);
                                        try {
                                          // Call Check-In API
                                          final response =
                                              await checkInViewModel
                                                  .handleCheckIn(
                                                      4); // User ID: 4
                                          if (response != null &&
                                              response['checkIn'] != null) {
                                            final checkInDetails =
                                                response['checkIn'][0];
                                            checkInViewModel.setCheckedIn(
                                              true,
                                              id: int.parse(
                                                  checkInDetails['checkInId']),
                                              checkInTime:
                                                  checkInDetails['checkInTime'],
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Check-in successful!\n'
                                                  'Date: ${checkInDetails['checkInDate']}\n'
                                                  'Time: ${checkInDetails['checkInTime']}',
                                                ),
                                              ),
                                            );

                                            setState(() {
                                              cTime =
                                                  checkInDetails['checkInTime'];
                                            });
                                          } else {
                                            throw Exception('Check-in failed');
                                          }
                                        } catch (e) {
                                          debugPrint("Error: $e");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Check-in operation failed!'),
                                            ),
                                          );
                                        } finally {
                                          checkInViewModel.setLoading(false);
                                        }
                                      }
                                    },
                                    //activeColor: Colors.green,
                                    inactiveTrackColor: Colors.red,
                                  ),
                                // Check-Out Switch
                                if (checkInViewModel.isCheckedIn)
                                  Switch(
                                    value: true,
                                    onChanged: (value) async {
                                      if (!value) {
                                        checkInViewModel.setLoading(true);
                                        try {
                                          // Call Check-Out API
                                          final response = await checkInViewModel
                                              .handleCheckOut(4,
                                                  1.5); // User ID: 4, Distance: 1.5
                                          if (response != null) {
                                            checkInViewModel
                                                .setCheckedIn(false);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Check-out successful!'),
                                              ),
                                            );
                                          } else {
                                            throw Exception('Check-out failed');
                                          }
                                        } catch (e) {
                                          debugPrint("Error: $e");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Check-out operation failed!'),
                                            ),
                                          );
                                        } finally {
                                          checkInViewModel.setLoading(false);
                                        }
                                      }
                                    },
                                    activeColor: Colors.green,
                                    //inactiveTrackColor: Colors.red,
                                  ),
                              ],
                            );
                          },
                        ),

                        // Consumer<CheckInViewModel>(
                        //   builder: (context, checkInViewModel, child) {
                        //     return Switch(
                        //       // The switch value is bound to `isCheckedIn`
                        //       value: checkInViewModel.isCheckedIn,
                        //       onChanged: (value) async {
                        //         checkInViewModel.setLoading(true); // Start loading
                        //         try {
                        //           if (value) {
                        //             // Handle Check-In
                        //             await checkInViewModel.handleCheckIn(4); // Replace 4 with actual userId
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //               const SnackBar(
                        //                 content: Text('Check-in successful!'),
                        //               ),
                        //             );
                        //           } else {
                        //             // Handle Check-Out
                        //             await checkInViewModel.handleCheckOut(4, 1.5); // Replace 4 and 1.5 with actual userId and distance
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //               const SnackBar(
                        //                 content: Text('Check-out successful!'),
                        //               ),
                        //             );
                        //           }
                        //         } catch (e) {
                        //           debugPrint("Error: $e");
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content: Text('Operation failed!'),
                        //             ),
                        //           );
                        //         } finally {
                        //           checkInViewModel.setLoading(false); // Stop loading
                        //         }
                        //       },
                        //       // Set active and inactive colors
                        //       activeColor: Colors.green, // Switch is green when checked
                        //       inactiveTrackColor: Colors.red, // Switch track is red when unchecked
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Grid Menu
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.access_time,
                  label: 'Leave Management',
                  onTap: () => Navigator.pushNamed(context, '/leaveManagement'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person,
                  label: 'Attendance Management',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AttendanceHistoryScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.home,
                  label: 'Work from Home',
                  onTap: () => Navigator.pushNamed(context, '/workFromHome'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.task,
                  label: 'Project Task',
                  onTap: () => Navigator.pushNamed(context, '/projectTask'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.bar_chart,
                  label: 'Performance',
                  onTap: () => Navigator.pushNamed(context, '/performance'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.schedule,
                  label: 'Shift Roster',
                  onTap: () => Navigator.pushNamed(context, '/shiftRoster'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.group,
                  label: 'Employee Onboarding',
                  onTap: () =>
                      Navigator.pushNamed(context, '/employeeOnboarding'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.business_center,
                  label: 'Recruitment & Hiring',
                  onTap: () =>
                      Navigator.pushNamed(context, '/recruitmentHiring'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.travel_explore,
                  label: 'Travel & Expense',
                  onTap: () => Navigator.pushNamed(context, '/travelExpense'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  label: 'Assets Management',
                  onTap: () =>
                      Navigator.pushNamed(context, '/assetsManagement'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.money,
                  label: 'Payroll Management',
                  onTap: () =>
                      Navigator.pushNamed(context, '/payrollManagement'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.analytics,
                  label: 'HR Reports & Data',
                  onTap: () => Navigator.pushNamed(context, '/hrReportsData'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
