import 'dart:developer';

import 'package:http/http.dart' as http;

Future<String> getUserId(String email) async {
  try {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:7094/api/User/get-user-by-id?email=$email'));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.statusCode.toString());

      return response.body;
    } else {
      log('Error: ${response.statusCode}');
      log(response.body);
      return "-1";
    }
  } catch (e) {
    log('Error: $e');
    return "-1";
  }
}
