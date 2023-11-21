import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        child: const Text(
          Strings.gButton,
          style: TextStyle(fontSize: 60),
        ),
        onPressed: () {
          fireBaseClass.signInWithGoogle();
          context.read<ProviderClass>().isSignIn();
          print(context.read<ProviderClass>().signedIn);
          if (context.read<ProviderClass>().signedIn == true) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
          print('Google SignIn');
        },
      )),
    );
  }
}
