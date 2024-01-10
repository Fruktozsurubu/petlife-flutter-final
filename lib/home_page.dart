import 'package:flutter/material.dart';
import 'package:petlife/pets.dart';
import 'package:petlife/profile_page.dart';
import 'package:petlife/utils/database_operations/get_pets.dart';
import 'package:petlife/utils/database_operations/get_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ana Sayfa"),
      ),
      body: Column(
        children: [
          Image.network(
              "https://i.ibb.co/4FsrZn4/Ekran-g-r-nt-s-2024-01-10-204204.png")
        ],
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }

  BottomAppBar bottomAppBar() {
    var petNotifier = context.read<PetNotifier>();
    var userNotifier = context.read<UserNotifier>();
    return BottomAppBar(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 236, 201, 20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.home,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () async {
                    petNotifier.fetchPetData();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? userId = prefs.getString("userId");
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pets(
                              userId: userId!,
                            ),
                          ),
                          (route) => false);
                    }
                  },
                  icon: const Icon(
                    Icons.pets,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    String? email = prefs.getString("email");
                    await userNotifier.fetchUserData();
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    email: email!,
                                  )),
                          (route) => false);
                    }
                  },
                  icon: const Icon(
                    Icons.person,
                    size: 30,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
