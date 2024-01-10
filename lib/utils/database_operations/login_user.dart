import 'dart:convert';
import 'dart:developer';

import 'package:petlife/home_page.dart';
import 'package:petlife/utils/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  LoginApi();
  bool isCompleted = false;
  Future<bool> loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:7094/api/User/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200 && context.mounted) {
      log('Successfully login ${response.body}');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('password', password);
      await prefs.setString('email', email);
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
      }

      return true;
    } else {
      if (context.mounted) {
        Dialogs().showErrorDialog(context, "Email veya şifre hatalı");
      }
    }

    return false;
  }
}
