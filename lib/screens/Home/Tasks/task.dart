// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/card.dart';

final TextEditingController textController = TextEditingController();
final TextEditingController inputValue = TextEditingController();

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderClass>().dataFirebase;
    context.read<ProviderClass>().getFirebaseDatas();
    // context.read<ProviderClass>().addFirebaseDataFirst();
  }

  @override
  Widget build(BuildContext context) {
    // Use the watch method from context to access the ProviderClass
    ProviderClass provider = context.watch<ProviderClass>();
    bool isLoading = provider.isLoading;

    // return Column(
    //   children: [
    //     _buildTextComposer(),
    return isLoading
        ? CircularProgressIndicator() // Show a loading indicator while data is being retrieved
        : CardBuilder();
    // const SizedBox(height: 16),

    //   ],
    // );
  }
}
