import 'package:flutter/material.dart';
import 'package:petlife/utils/database_operations/register_user.dart';
import 'package:petlife/utils/dialogs.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController fullNameController = TextEditingController();

TextEditingController passwordController = TextEditingController();
String imageUrl = "";
bool isImageValid = false;
bool isReSubmitEnabled = false;

class _RegisterPageState extends State<RegisterPage> {
  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                )),
          ),
          backgroundColor: Colors.white,
          body: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            controller: fullNameController,
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange.shade100),
                              ),
                              labelText: "İsim",
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "İsim giriniz";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange.shade100),
                              ),
                              labelText: "e-posta",
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "e-posta giriniz";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            controller: passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange.shade100),
                              ),
                              labelText: "şifre",
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "şifre giriniz";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                          child: MaterialButton(
                        color: Colors.orange,
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              fullNameController.text.isEmpty) {
                            Dialogs().showErrorDialog(
                                context, "Alanlar doldurulmalıdır");
                          } else {
                            RegistrationApi().registerUser(
                                context,
                                fullNameController.text,
                                emailController.text,
                                passwordController.text,
                                imageUrl);
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            height: 50,
                            width: 150,
                            child: const Center(child: Text("Kayıt Ol"))),
                      )),
                    ),
                  ],
                ),
              ),
            ),
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
