import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petlife/utils/class/pet_class.dart';

class PetNotifier extends ChangeNotifier {
  List<Pet> pets = [];

  Future<void> fetchPetData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:7094/api/Pet/get-all-pets'));

      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final data = json.decode(response.body);

        pets = (data as List).map((petData) {
          return Pet(
            petId: petData['petId'],
            ownerId: petData['ownerId'],
            petImageUrl: petData['petImageUrl'],
            name: petData['name'],
            age: petData['age'],
            weight: petData['weight'],
            type: petData['type'],
            sterilizationStatus: petData['sterilizationStatus'],
            gender: petData['gender'],
            breed: petData['breed'],
          );
        }).toList();

        log("Pets lenght: ${pets.length.toString()}");
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
