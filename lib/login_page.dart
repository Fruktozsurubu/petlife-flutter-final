import 'package:flutter/material.dart';
import 'package:petlife/home_page.dart';
import 'package:petlife/register.dart';
import 'package:petlife/utils/database_operations/get_user_id.dart';
import 'package:petlife/utils/database_operations/login_user.dart';
import 'package:petlife/utils/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  void dispose() {
    emailController.text = "";
    passwordController.text = "";
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
          backgroundColor: Colors.white,
          body: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: deviceWidth,
                      height: deviceHeight / 3.5,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("lib/assets/images/elips-1.png"),
                        fit: BoxFit.cover,
                      )),
                      child: Container(
                        width: deviceWidth,
                        height: deviceHeight / 3.5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("lib/assets/images/logo-1.png"),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text("şifremi unuttum")),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                          child: MaterialButton(
                        color: Colors.orange,
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            if (mounted) {
                              Dialogs().showErrorDialog(
                                  context, "Email ya da şifre alanı boş");
                            }
                          } else {
                            String userId =
                                await getUserId(emailController.text);
                            if (userId != "-1") {
                              prefs.setString("userId", userId);
                            }
                            if (mounted) {
                              LoginApi().loginUser(
                                  context,
                                  emailController.text,
                                  passwordController.text);
                            }
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            height: 50,
                            width: 150,
                            child: const Center(child: Text("Giriş Yap"))),
                      )),
                    ),
                    Center(
                        child: MaterialButton(
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height: 50,
                          width: 150,
                          child: const Center(child: Text("Kayıt Ol"))),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");
    if (email != null || password != null) {
      if (mounted) {
        LoginApi().loginUser(context, email!, password!);
      }
    }
  }
}
