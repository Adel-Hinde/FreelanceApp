import 'package:end_project/Jobs/jobs_screen.dart';
import 'package:end_project/LoginPage/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.data == null) {
            print("user is not logged in yet");
            return const Login();
          } else if (userSnapshot.hasData) {
            print("user is already logged in yet");
            return const JobsScreen();
          } else if (userSnapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("An error has been occure , Try again Latter"),
              ),
            );
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text("Something went Wrong") ,
            ),
          );
        });
  }
}
