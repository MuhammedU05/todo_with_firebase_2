// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
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
      print('Map List Cleared : $mapList');
      notifyListeners();
    } catch (e) {
      print("Error signing out with Google: $e");
    }
  }

  void clearDataSignOut(BuildContext context) {
    try {
      signOut(context);
      // Clear the data here
      print('Signed Out');
      mapList.clear();
      print('MapList in Signout : $mapList');
      context.read<FirebaseProviderClass>().updateUserMap();
      print('Email : ${fireBaseClass?.getCurrentUserEmail()}');
      print('object');
      notifyListeners();
    } on Exception catch (e) {
      print('Error in Signing Out : $e');
    }
// Notify listeners after clearing the data
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

  Future<void> addCollection() async {
    try {
      print('Add Collection Of Users Running');
      var allUserGet = await allUserRef.get();
      if (!allUserGet.exists ||
          allUserGet.reference.id == firebaseAuthInstance.currentUser!.uid) {
      print('Add Collection Of Users Running and Current User Doc Not Found');
        await allUserRef.set({
          'UID': firebaseAuthInstance.currentUser?.uid ??
              FirebaseAuth.instance.currentUser?.uid,
          'NAME': firebaseAuthInstance.currentUser?.displayName ??
              currentUserFDetails,
          'JOINED ON': DateTime.now().toString(),
          'Photo': firebaseAuthInstance.currentUser?.photoURL
        });
        print('All User Collection Created');
      } else {
        print('All User Collection Exists');
      }
      notifyListeners();
    } on Exception catch (e) {
      print('Adding Collection Error : $e');
    }
  }

  Future<void> saveUser() async {}

  updateCurrentUser() {
    pic = FirebaseAuth.instance.currentUser?.photoURL?.toString() ?? defaultPic;
    currentUserFDetails = FirebaseAuth.instance.currentUser?.displayName ?? "";
    // currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
}
