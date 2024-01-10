import 'package:flutter/material.dart';
import 'package:petlife/login_page.dart';
import 'package:petlife/utils/database_operations/get_pets.dart';
import 'package:petlife/utils/database_operations/get_user.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PetNotifier>(
          create: (_) => PetNotifier(),
        ),
        ChangeNotifierProvider<UserNotifier>(
          create: (_) => UserNotifier(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 228, 150, 150)),
            primarySwatch: Colors.blue,
          ),
          home: const LoginPage()),
    );
  }
}
