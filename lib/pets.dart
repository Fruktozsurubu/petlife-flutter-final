import 'package:flutter/material.dart';
import 'package:petlife/create_pet.dart';
import 'package:petlife/home_page.dart';
import 'package:petlife/profile_page.dart';
import 'package:petlife/utils/database_operations/get_pets.dart';
import 'package:petlife/utils/database_operations/get_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pets extends StatefulWidget {
  final String userId;
  const Pets({super.key, required this.userId});

  @override
  State<Pets> createState() => _PetsState();
}

String userId = "";

class _PetsState extends State<Pets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pets"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 201, 20),
                  borderRadius: BorderRadius.circular(30)),
              height: 0,
              width: 90,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPet(),
                        ));
                  },
                  child: const Center(child: Text("Add Pet"))),
            ),
          )
        ],
      ),
      body: listView(),
      bottomNavigationBar: bottomAppBar(),
    );
  }

  Widget listView() {
    var petNotifier = context.read<PetNotifier>();
    return ListView.builder(
      itemCount: petNotifier.pets
          .where((p) => p.ownerId == widget.userId)
          .toList()
          .length,
      itemBuilder: (context, index) {
        var pet = petNotifier.pets
            .where((p) => p.ownerId == widget.userId)
            .toList()[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      pet.petImageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(pet.name),
                  subtitle: Row(
                    children: [
                      Text(pet.gender == 1
                          ? "Erkek"
                          : pet.gender == 2
                              ? "Dişi"
                              : ""),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(pet.type == 1
                          ? "Kedi"
                          : pet.type == 2
                              ? "Köpek"
                              : pet.type == 3
                                  ? "Kuş"
                                  : "Error"),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [const Text("Yaş "), Text(pet.age)],
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [Text(pet.weight), const Text(" Kg")],
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(pet.sterilizationStatus == 1
                          ? "Kısır"
                          : "Kısır Değil")
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BottomAppBar bottomAppBar() {
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);
                  },
                  icon: const Icon(
                    Icons.home,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {});
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
