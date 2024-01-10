import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petlife/utils/database_operations/create_pet.dart';
import 'package:petlife/utils/dialogs.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

bool _switchValue = false;
String imageUrl = "";
bool isImageValid = false;
bool isReSubmitEnabled = false;
String selectedCategory = "Kedi";
String selectedGender = "Erkek";
int chosenCategory = 1;
int chosenGender = 1;
int isSterilization = 0;
TextEditingController nameController = TextEditingController();
TextEditingController ageController = TextEditingController();
TextEditingController weightController = TextEditingController();
final List<String> categories = [
  'Kedi',
  'Köpek',
  'Kuş',
];
final Map<String, int> categoryIndices = {
  'Kedi': 1,
  'Köpek': 2,
  'Kuş': 3,
};
final List<String> gender = [
  'Erkek',
  'Dişi',
];
final Map<String, int> genderIndices = {
  'Erkek': 1,
  'Dişi': 2,
};

class _AddPetState extends State<AddPet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Pet"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageArea(context),
              Visibility(
                visible: isReSubmitEnabled,
                child: ElevatedButton(
                    onPressed: () {
                      _showImageInputSheet(context);
                    },
                    child: const Text('Resubmit')),
              ),
              TextField(
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  decoration: InputDecoration(
                      label: const Text("Name"),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ))),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: TextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: ageController,
                        decoration: InputDecoration(
                            label: const Text("Yaş"),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ))),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: TextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: weightController,
                        decoration: InputDecoration(
                            label: const Text("Kilo"),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ))),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [categoryDropdown(), genderDropdown()],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Kısırlık Durumu",
                        style: TextStyle(fontSize: 16),
                      ),
                      CupertinoSwitch(
                        value: _switchValue,
                        onChanged: (value) {
                          setState(() {
                            _switchValue = value;
                            if (_switchValue) {
                              isSterilization = 1;
                            } else {
                              isSterilization = 0;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 236, 201, 20),
                ),
                child: MaterialButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        ageController.text.isEmpty ||
                        weightController.text.isEmpty ||
                        imageUrl.isEmpty) {
                      Dialogs().showErrorDialog(
                          context, "Bir veya birden fazla alan boş.");
                    } else {
                      CreatePet().createPet(
                          context,
                          imageUrl,
                          nameController.text,
                          ageController.text,
                          weightController.text,
                          chosenCategory,
                          chosenGender,
                          isSterilization);
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Hayvanı Ekle",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding categoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
            )),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButton<String>(
            underline: const SizedBox(),
            value: selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
                chosenCategory = categoryIndices[selectedCategory] ?? 1;
                log(chosenCategory.toString());
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  Padding genderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
            )),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButton<String>(
            underline: const SizedBox(),
            value: selectedGender,
            onChanged: (String? newValue) {
              setState(() {
                selectedGender = newValue!;
                chosenGender = genderIndices[selectedGender] ?? 1;
              });
            },
            items: gender.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  Padding imageArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 20,
              color: Colors.grey.withOpacity(0.4),
              blurStyle: BlurStyle.outer,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width / 2.4,
        height: MediaQuery.of(context).size.width / 2.4,
        child: imageUrl == ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showImageInputSheet(context);
                        },
                        child: const Text('Fotoğraf Ekle'),
                      ),
                    ],
                  ),
                ],
              )
            : Image.network(
                imageUrl,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  isImageValid = false;

                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Hata oluştu. Tekrar deneyin.'),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showImageInputSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        isReSubmitEnabled = true;
        return SingleChildScrollView(
          child: Container(
            height: 600,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Profil linki girin ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    imageUrl = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Fotoğraf Linki',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Optionally, you can update the image in the parent widget
                    setState(() {
                      imageUrl = imageUrl;
                    });
                  },
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
