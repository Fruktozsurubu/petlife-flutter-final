import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petlife/utils/class/user_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends ChangeNotifier {
  List<User> user = [];

  Future<void> fetchUserData() async {
    var prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:7094/api/User/get-user-info?email=$email'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        user = (data as List).map((userData) {
          return User(
            userId: userData['userId'],
            fullName: userData['fullName'],
            profileUrl: userData['profileUrl'],
            email: userData['email'],
          );
        }).toList();

        log("User lenght: ${user.length.toString()}");
      } else {
        log('Error: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      notifyListeners();
    }
  }
}
