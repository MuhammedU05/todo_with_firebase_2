import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';

class CardBuilder extends StatefulWidget {
  const CardBuilder({super.key});

  @override
  State<CardBuilder> createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  @override
  Widget build(BuildContext context) {
    // var provider = context.read<ProviderClass>();
    return SizedBox.expand(
        child: ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Card(
        child: Container(
          width: double.maxFinite - 20,
          height: 300,
        ),
        color: Colors.green,
      );
    }));
  }
}
