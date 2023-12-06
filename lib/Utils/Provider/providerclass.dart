// provider_class.dart

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_with_firebase_2/Firebase/things.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';

class ProviderClass extends ChangeNotifier {
  // var currentUser = FirebaseAuth.instance.currentUser;



  // var currentUser = FirebaseAuth.instance.currentUser;
  // final userCollection = FirebaseFirestore.instance.collection('Users');

  // Map<String, dynamic> mapList = {};





  Future<String> getCurrentUserProfile() async {
    var pic = FirebaseAuth.instance.currentUser?.photoURL?.toString() ?? "";
    notifyListeners();
    return pic;
  }




  String getPriorityString(Priority priority) {
    for (var option in priorityOptions) {
      if (option.$1 == priority) {
        return option.$2;
      }
    }
    notifyListeners();
    return ''; // Default value if not found
  }

}
