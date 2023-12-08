// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/screens/Home/Complete/completedcard.dart';


class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().dataFirebase;
    context.read<FirebaseProviderClass>().getFirebaseDatas();
      context.read<FirebaseProviderClass>().updateData();
    print(
        'Photo URL : ${FirebaseAuth.instance.currentUser?.photoURL?.toString()}');
    print('Display Name : ${FirebaseAuth.instance.currentUser?.displayName}');
    print('Current User In Task : ${FirebaseAuth.instance.currentUser}');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        // ? CircularProgressIndicator() // Show a loading indicator while data is being retrieved
        ? Text('Loading Please wait...')
        : CompletedCardBuilder();
  }
}
