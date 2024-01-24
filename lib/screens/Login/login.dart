// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
// import 'package:todo_with_firebase_2/packages/custom_motion_widget/custom_motion_widget.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';
import '../../packages/custom_motion_widget/lib/custom_motion_widget.dart';
import '/Utils/imports.dart';
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
    context.read<LoginProviderClass>().currentUserSaver();
    login(context);
    // context.read<ProviderClass>().allData?.clear();
    print('Email in login : ${currentUserAll?.email}');
    print('All Data in login : $mapList');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Use Home Button to go back'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () async {
            // //Login Button -> Google SignIn Function
            // try {
            //   await context.read<LoginProviderClass>().signInWithGoogle();
            //   // Updating Current User
            //   context.read<LoginProviderClass>().updateCurrentUser();
            //   if (signedIn == false) {
            //     // If The User is Signed in -> Navigate to HomePage
            //     Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => const HomePage()),
            //     );
            //   } else {
            //     // Handle the case where sign-in was not successful

            //     print('Google sign-in failed');
            //   }
            // } catch (e) {
            //   // Handle other errors that might occur during sign-in
            //   print('Error signing in with Google: $e');
            // }
            login(context);
          },
          child: Column(
            children: [
              // const Spacer(),
              //  const CustomMotionWidget(),
              const Spacer(),
              Center(
                // Google Logo
                child: SizedBox(
                  width: 100,
                  child: Image.asset('assets/GoogleLogo.png'),
                ),
              ),
              const Text(
                'Click To Sign In',
                style: TextStyle(fontSize: 20),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> login(BuildContext context) async {
  //Login Button -> Google SignIn Function
  try {
    await context.read<LoginProviderClass>().signInWithGoogle();
    // Updating Current User
    context.read<LoginProviderClass>().updateCurrentUser();
    if (signedIn == false) {
      // If The User is Signed in -> Navigate to HomePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Handle the case where sign-in was not successful

      print('Google sign-in failed');
    }
  } catch (e) {
    // Handle other errors that might occur during sign-in
    print('Error signing in with Google: $e');
  }
}
