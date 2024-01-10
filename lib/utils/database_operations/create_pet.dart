import 'dart:convert';
import 'dart:developer';

import 'package:petlife/home_page.dart';
import 'package:petlife/pets.dart';
import 'package:petlife/utils/database_operations/get_pets.dart';
import 'package:petlife/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreatePet {
  CreatePet();
  bool isCompleted = false;
  Future<bool> createPet(
    BuildContext context,
    String imageUrl,
    String name,
    String age,
    String weight,
    int type,
    int gender,
    int ster,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:7094/api/Pet/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<Object, Object>{
        "petId": "sdsd",
        "ownerId": userId!,
        "petImageUrl": imageUrl,
        "name": name,
        "age": age,
        "weight": weight,
        "type": type,
        "sterilizationStatus": ster,
        "gender": gender,
        "breed": -1
      }),
    );
    var petNotifier = context.read<PetNotifier>();
    await petNotifier.fetchPetData();
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200 && context.mounted) {
      log('Successfully created $name');

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Pets(
                userId: userId,
              ),
            ),
            (route) => false);
      }

      return true;
    } else {
      if (context.mounted) {
        Dialogs().showErrorDialog(
            context, "Bir hata oluştu! Lütfen daha sonra deneyiniz");
      }
    }

    return false;
  }
}
