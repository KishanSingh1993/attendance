// File: login_view_model.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    final response = await ApiService.login(username, password);

    isLoading = false;
    notifyListeners();

    if (response != null && response['status'] == 1) {
      // Extract user data from response
      final user = response['login'][0];

      // Save all data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user['userId']);
      await prefs.setString('roleId', user['roleId']);
      await prefs.setString('userName', user['userName']);
      await prefs.setString('empCode', user['empCode']);
      await prefs.setString('empEmail', user['empEmail']);
      await prefs.setString('profileImage', user['profileImage'] ?? '');
      await prefs.setBool('isLoggedIn', true);

      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all session data
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      return {
        'userId': prefs.getString('userId'),
        'roleId': prefs.getString('roleId'),
        'userName': prefs.getString('userName'),
        'empCode': prefs.getString('empCode'),
        'empEmail': prefs.getString('empEmail'),
        'profileImage': prefs.getString('profileImage'),
      };
    }
    return null;
  }
}

// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
//
// class LoginViewModel extends ChangeNotifier {
//   bool isLoading = false;
//
//   Future<bool> login(String username, String password) async {
//     isLoading = true;
//     notifyListeners();
//
//     final response = await ApiService.login(username, password);
//
//     isLoading = false;
//     notifyListeners();
//
//     if (response != null && response['status'] == 1) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }