import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/login_screen.dart';
import 'views/dashboard_screen.dart';
import 'view_models/login_view_model.dart';
import 'view_models/checkin_view_model.dart';
import 'view_models/attendance_view_model.dart';
import 'view_models/history_track_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CheckInViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceHistoryViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(), // Use SplashScreen as the home
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession(); // Check session on app launch
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Redirect based on session existence
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Simple loading indicator
      ),
    );
  }
}













// import 'package:attendance_tracker_app/view_models/history_track_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'views/login_screen.dart';
// import 'views/dashboard_screen.dart';
// import 'views/checkin_screen.dart';
// import 'views/checkout_screen.dart';
// import 'views/attendance_history_screen.dart';
// import 'views/attendance_details_screen.dart';
// import 'view_models/login_view_model.dart';
// import 'view_models/checkin_view_model.dart';
// import 'view_models/checkout_view_model.dart';
// import 'view_models/attendance_view_model.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => LoginViewModel()),
//         ChangeNotifierProvider(create: (_) => CheckInViewModel()),
//         //ChangeNotifierProvider(create: (_) => CheckOutViewModel()),
//         ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
//         ChangeNotifierProvider(create: (_) => AttendanceHistoryViewModel()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Attendance Tracker',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         initialRoute: '/',
//         routes: {
//           '/': (context) => LoginScreen(),
//           '/dashboard': (context) => DashboardScreen(),
//           // '/checkin': (context) => CheckInScreen(),
//           // '/checkout': (context) => CheckOutScreen(),
//           // '/attendanceHistory': (context) => AttendanceHistoryScreen(),
//           // '/attendanceDetails': (context) => AttendanceDetailsScreen(),
//         },
//       ),
//     );
//   }
// }