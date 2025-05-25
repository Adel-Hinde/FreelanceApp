import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:end_project/Jobs/jobs_screen.dart';
import 'package:end_project/Jobs/upload_job.dart';
import 'package:end_project/Search/profile_cmpany.dart';
import 'package:end_project/Search/search_company.dart';
import 'package:end_project/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  BottomNavigationBarForApp({super.key, required this.indexNum});

  int indexNum = 0;

  void _logout(context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              "Do you want to Log Out",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
              TextButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.canPop(context)
                        ? Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const UserState()))
                        : null;
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 60,
      index: indexNum,
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      items: const [
        Icon(
          Icons.list,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.add,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.person_pin,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.exit_to_app,
          size: 19,
          color: Colors.black,
        ),
      ],
      onTap: (value) {
        if (value == 0) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const JobsScreen()));
        } else if (value == 1) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AllWorkerScreen()));
        } else if (value == 2) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const UploadJobNow()));
        } else if (value == 3) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfileScreen()));
        } else if (value == 4) {
          _logout(context);
        }
      },
    );
  }
}
