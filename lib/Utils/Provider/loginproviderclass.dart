// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/screens/Login/login.dart';

class LoginProviderClass extends ChangeNotifier {
  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      signedIn = false;
      print("User signed out with Google");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => const Login()));
      mapList.clear();
      mapListCompleted.clear();
      print('Map List Cleared : $mapList');
      notifyListeners();
    } catch (e) {
      print("Error signing out with Google: $e");
    }
  }

  void clearDataSignOut(BuildContext context) {
    signOut(context);
    print('Signed Out');
    mapList.clear();
    mapListCompleted.clear();
    print('MapList in Signout : $mapList');
    context.read<FirebaseProviderClass>().updateUserMap();

    // Clear the data here
    print('Email : ${fireBaseClass?.getCurrentUserEmail()}');
    print('object');
    notifyListeners(); // Notify listeners after clearing the data
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print(" google User : $googleUser");
    print(" Credential : $credential");
    print(
        'Photo URL : ${FirebaseAuth.instance.currentUser?.photoURL?.toString()}');
    print('Display Name : ${FirebaseAuth.instance.currentUser?.displayName}');
    print(
        'Current User In Login Provider: ${FirebaseAuth.instance.currentUser}');

    // addFirebaseDataFirst();
    notifyListeners();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // void dispose() {
  //   super.dispose();
  //   // Remove any additional cleanup code if necessary
  // }

  updateCurrentUser() {
    pic = user?.photoURL?.toString() ?? defaultPic;
    currentUserFDetails = user?.displayName ?? "";
    // currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
}
