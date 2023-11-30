// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Home/Complete/alertbox.dart';

class CardBuilder extends StatefulWidget {
  const CardBuilder({Key? key}) : super(key: key);

  @override
  State<CardBuilder> createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  var priorityColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ProviderClass>();

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.mapList.isEmpty) {
      return const Center(
        child: Text('Add Task'),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: provider.mapList.length,
        itemBuilder: (context, index) {
          String taskName = provider.mapList.keys.elementAt(index);
          Map<String, dynamic> task = provider.mapList[taskName] ?? {};
          if (task['Priority'] == 'Mid') {
            priorityColor = Colors.white;
          } else if (task['Priority'] == 'Low') {
            priorityColor = Colors.green.shade400;
          } else if (task['Priority'] == 'High') {
            priorityColor = Colors.red;
          } else {
            priorityColor = Colors.white;
          }
          return GestureDetector(
            onTap: () {
              print(
                  "$taskName \n  ${task['Created Date']} \n ${task['Created Time']}");
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 10,
              child: Container(
                color: Colors.grey.shade600,
                width: double.maxFinite,
                height: 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${Strings.taskName}  ${task['Task Name'] ?? 'N/A'}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${Strings.createdOn} ',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              task['Created Time'] ?? 'N/A',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          '${Strings.priority} ${task['Priority']}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                            color: priorityColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          child: Column(
                            children: [
                              Text('${Strings.notCompleted}',
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text('${Strings.completed} ?'),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {

                                                  context.read<ProviderClass>().updateMessage(
                                                    true
                                                  );
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.done_outline_sharp,
                                    color: Colors.lightGreen, fill: 1),
                                iconSize: 40,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
