// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';

//Login Page
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

//Clearing Previous Data If There is any
class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    mapList.clear();
    // context.read<ProviderClass>().allData?.clear();
    print('Email in login : ${FirebaseAuth.instance.currentUser?.email}');
    print('All Data in login : $mapList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text(
            TStrings.gButton,
            style: TextStyle(fontSize: 60),
          ),
          onPressed: () async {
            //Login Button -> Google SignIn Function
            try {
              await context.read<LoginProviderClass>().signInWithGoogle();
              // var signedIn = context.read<ProviderClass>().signedIn;
              // Updating Current User
              context.read<LoginProviderClass>().updateCurrentUser();
              if (signedIn == false) {
                // If The User is Signed in -> Navigate to HomePage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                // context.read<ProviderClass>().updateCurrentUser();
              } else {
                // Handle the case where sign-in was not successful
                print('Google sign-in failed');
              }
            } catch (e) {
              // Handle other errors that might occur during sign-in
              print('Error signing in with Google: $e');
            }
          },
        ),
      ),
    );
  }
}
