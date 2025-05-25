import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:end_project/Services/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Persistent {
  static List<String> jobCategoryList = [
    "Architecture Data",
    "Education and Training" ,
    "Development - Programm" ,
    "Business" ,
    "Information Technology" ,
    "Human Resources" ,
    "Marketing",
    "Design",
    "Accounting"
  ];
    void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
      name = userDoc.get('name');
      location = userDoc.get('location');
  }
}
