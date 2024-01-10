import 'package:flutter/material.dart';
import 'package:petlife/home_page.dart';
import 'package:petlife/login_page.dart';
import 'package:petlife/pets.dart';
import 'package:petlife/utils/class/user_class.dart';
import 'package:petlife/utils/database_operations/get_pets.dart';
import 'package:petlife/utils/database_operations/get_user.dart';
import 'package:petlife/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            infoArea(context),
            const SizedBox(
              height: 25,
            ),
            contact(context),
            const SizedBox(
              height: 25,
            ),
            signOut(context)
          ],
        ),
      ),
      bottomNavigationBar: bottomAppBar(),
    );
  }

  Container signOut(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 150, 150),
        borderRadius: BorderRadius.circular(15),
      ),
      child: MaterialButton(
        onPressed: () async {
          var prefs = await SharedPreferences.getInstance();
          prefs.remove("email");
          prefs.remove("password");
          prefs.remove("userId");
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false);
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Çıkış Yap",
                style: TextStyle(fontSize: 20),
              ),
              Icon(
                Icons.logout_outlined,
                size: 22,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container contact(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 150, 150),
        borderRadius: BorderRadius.circular(15),
      ),
      child: MaterialButton(
        onPressed: () {
          showSheet(context);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "İletişim",
                style: TextStyle(fontSize: 20),
              ),
              Icon(
                Icons.phone,
                size: 22,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container infoArea(BuildContext context) {
    var userNotifier = context.read<UserNotifier>();
    var user = userNotifier.user.where((u) => u.email == widget.email).first;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 150, 150),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            user.profileUrl.isEmpty ? errorPic() : profilePic(user),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Divider(
                height: 1,
                color: Colors.black,
              ),
            ),
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              user.userId,
              style: const TextStyle(fontSize: 13),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Divider(
                height: 1,
                color: Colors.black,
              ),
            ),
            Text(
              user.email,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Padding profilePic(User user) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
          height: 230,
          width: 230,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(user.profileUrl))),
    );
  }

  Padding errorPic() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 230,
        width: 230,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.brown,
        ),
        child: const Icon(
          Icons.person,
          size: 80,
        ),
      ),
    );
  }

  BottomAppBar bottomAppBar() {
    var petNotifier = context.read<PetNotifier>();
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
                  onPressed: () {},
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

  void showSheet(context) {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+905538795734",
    );
    var whatsappUrl =
        "whatsapp://send?phone=+905538795734&text=Hi can you help me?";

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 253, 253, 253),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            // Define padding for the container.
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            // Create a Wrap widget to display the sheet contents.
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone Call'),
                  onTap: () {
                    launchUrl(launchUri);
                    Navigator.pop(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  leading: Image.asset('lib/assets/images/whatsapp.png',
                      width: 24, height: 24), // Replace with your WhatsApp icon
                  title: const Text('WhatsApp'),
                  onTap: () {
                    try {
                      launchUrl(Uri.parse(whatsappUrl));
                    } catch (e) {
                      //To handle error and display an error message
                      Dialogs().showErrorDialog(context,
                          "An error occurred while launching WhatsApp");
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
