// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/card.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().dataFirebase;
    context.read<FirebaseProviderClass>().getFirebaseDatas();
    // context.read<ProviderClass>().addFirebaseDataFirst();    
    print(
        'Photo URL : ${FirebaseAuth.instance.currentUser?.photoURL?.toString()}');
    print('Display Name : ${FirebaseAuth.instance.currentUser?.displayName}');
    print('Current User In Task : ${FirebaseAuth.instance.currentUser}');
  }

  @override
  Widget build(BuildContext context) {
    // Use the watch method from context to access the ProviderClass
    FirebaseProviderClass provider = context.watch<FirebaseProviderClass>();
    // bool isLoading = provider.isLoading;
    
    context.read<FirebaseProviderClass>().dataFirebase;

    // return Column(
    //   children: [
    //     _buildTextComposer(),
    return isLoading
        // ? CircularProgressIndicator() // Show a loading indicator while data is being retrieved
        ? Text('Loading Please wait...')
        : CardBuilder();
    // const SizedBox(height: 16),

    //   ],
    // );
  }
}
