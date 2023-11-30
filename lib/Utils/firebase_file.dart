// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';

class FireBaseClass {
  String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }
}
