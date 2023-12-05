// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Login/login.dart';

class LoginProviderClass extends ChangeNotifier {
  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      context.read<ProviderClass>().signedIn = false;
      print("User signed out with Google");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => const Login()));
      context.read<ProviderClass>().mapList.clear();
      print('Map List Cleared : ${context.read<ProviderClass>().mapList}');
      notifyListeners();
    } catch (e) {
      print("Error signing out with Google: $e");
    }
  }

  void clearDataSignOut(BuildContext context) {
    signOut(context);
    print('Signed Out');
    context.read<ProviderClass>().mapList.clear();
    print('MapList in Signout : ${context.read<ProviderClass>().mapList}');
    context.read<ProviderClass>().updateUserMap();

    // Clear the data here
    print('Email : ${fireBaseClass?.getCurrentUserEmail()}');
    print('object');
    notifyListeners(); // Notify listeners after clearing the data
  }
}
