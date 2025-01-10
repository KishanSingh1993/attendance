// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../view_models/checkin_view_model.dart';
//
// class CheckInScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final checkInViewModel = Provider.of<CheckInViewModel>(context);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Check In')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: checkInViewModel.isLoading
//               ? null
//               : () async {
//             final success = await checkInViewModel.checkIn();
//             if (success) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Check-in successful!')),
//               );
//               Navigator.pushNamed(context, '/dashboard');
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Check-in failed')),
//               );
//             }
//           },
//           child: checkInViewModel.isLoading ? CircularProgressIndicator() : Text('Check In'),
//         ),
//       ),
//     );
//   }
// }
