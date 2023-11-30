// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Add%20Task/addtask.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/card.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';

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
    context.read<ProviderClass>().getFirebaseDatas();
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
