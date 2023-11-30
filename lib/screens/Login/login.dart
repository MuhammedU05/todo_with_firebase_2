// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderClass>().mapList.clear();
    // context.read<ProviderClass>().allData?.clear();
    print('Email in login : ${FirebaseAuth.instance.currentUser?.email}');
    print('All Data in login : ${context.read<ProviderClass>().mapList}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text(
            Strings.gButton,
            style: TextStyle(fontSize: 60),
          ),
          onPressed: () async {
            // print('Hello : ${fireBaseClass?.getCurrentUserEmail()}');
            try {
              await context.read<ProviderClass>().signInWithGoogle();
              var signedIn = context.read<ProviderClass>().signedIn;

              if (signedIn == false) {
                context.read<ProviderClass>().updateCurrentUser();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                context.read<ProviderClass>().updateCurrentUser();
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
