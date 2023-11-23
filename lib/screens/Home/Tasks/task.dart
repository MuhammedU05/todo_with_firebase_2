import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/card.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return CardBuilder(data: [],);
  }
}
