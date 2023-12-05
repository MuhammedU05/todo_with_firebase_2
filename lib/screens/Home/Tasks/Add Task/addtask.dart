// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskNameController = TextEditingController();
  late List<String> groups = ['Me'];
  // final List<String> priority = ['Low', 'Mid', 'High'];
  late String? _selectedGroup;
  var _selectedPriority;
  String time = formatDate(DateTime.now(), [HH, ' : ', nn]);
  String date = formatDate(DateTime.now(), [dd, ' - ', mm, ' - ', yy]);

  final List<bool> _toggleButtonsSelection =
      Priority.values.map((Priority e) => e == Priority.mid).toList();
  // Set<Priority> _segmentedButtonSelection = <Priority>{Priority.mid};
  final Color _selectedColor = Colors.yellow.shade400;

  @override
  void initState() {
    super.initState();
    _selectedGroup = groups.isNotEmpty ? groups[0] : null;
    if (_toggleButtonsSelection.isNotEmpty) {
      // _selectedPriority = _toggleButtonsSelection[1];
      _selectedPriority = 'Mid';
    } else {
      _selectedPriority = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          // _selectedPriority = 'Mid';
          _toggleButtonsSelection[1] = true;
          _toggleButtonsSelection[2] = false;
          _toggleButtonsSelection[0] = false;
          print(FirebaseAuth.instance.currentUser);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                //To Change State of the AlertDialog
                return StatefulBuilder(
                  builder: (context, StateSetter setState) {
                    return AlertDialog(
                      title: const Text(TStrings.addTask),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: taskNameController,
                            decoration: InputDecoration(
                              labelText: TStrings.addTask,
                              icon: profileIcon,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _selectedGroup,
                            items: groups.map((group) {
                              return DropdownMenuItem<String>(
                                value: group,
                                child: Text(group),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedGroup = newValue;
                                });
                              }
                            },
                          ),
                          // To Set Prio
                          ToggleButtons(
                              textStyle: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                              splashColor: Colors.black45,
                              fillColor: Colors.black54,
                              borderWidth: 5,
                              selectedBorderColor: Colors.black54,
                              selectedColor: _selectedColor,
                              constraints: const BoxConstraints(
                                minHeight: 32.0,
                                minWidth: 56.0,
                              ),
                              onPressed: (int value) {
                                setState(() {
                                  print(_toggleButtonsSelection);
                                  if (value == 1) {
                                    _toggleButtonsSelection[1] = true;
                                    _toggleButtonsSelection[2] = false;
                                    _toggleButtonsSelection[0] = false;
                                    _selectedPriority = 'Mid';
                                    print(_selectedPriority);
                                  } else if (value == 0) {
                                    _toggleButtonsSelection[1] = false;
                                    _toggleButtonsSelection[2] = false;
                                    _toggleButtonsSelection[0] = true;
                                    _selectedPriority = 'High';
                                    print(_selectedPriority);
                                  } else if (value == 2) {
                                    _toggleButtonsSelection[1] = false;
                                    _toggleButtonsSelection[2] = true;
                                    _toggleButtonsSelection[0] = false;
                                    _selectedPriority = 'Low';
                                    print(_selectedPriority);
                                  } else {
                                    _selectedPriority = 'Mid';
                                  }

                                  print(_toggleButtonsSelection);
                                });
                              },
                              isSelected: _toggleButtonsSelection,
                              children: priorityOptions
                                  .map(((Priority, String) priorityQ) =>
                                      Text(priorityQ.$2))
                                  .toList()),
                          // DropdownButton<String>(
                          //   value: _selectedPriority,
                          //   items: priority.map((priority) {
                          //     return DropdownMenuItem<String>(
                          //       value: priority,
                          //       child: Text(priority),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? newPriority) {
                          //     if (newPriority != null) {
                          //       _selectedPriority = newPriority;
                          //       setState(() {
                          //         // print(grou)
                          //       });
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                      actions: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            taskNameController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text(TStrings.cancel),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {

                // context.read<ProviderClass>().addFirebaseDataFirst();
                            if (taskNameController.text.isNotEmpty) {
                              setState(() {
                                context.read<ProviderClass>().addFirebaseData(
                                    taskNameController.text.toString(),
                                    formatDate(DateTime.now(), [HH, ' : ', nn]),
                                    formatDate(DateTime.now(),
                                        [dd, ' - ', mm, ' - ', yy]),
                                    _selectedGroup!,
                                    _selectedPriority!,
                                    false
                                    // priority
                                    );

                                print("Added");

                                context.read<ProviderClass>().updateData();
                                // context.read<ProviderClass>().notifyListeners();

                                print("testing");
                                taskNameController.clear();
                                // context.read<ProviderClass>().dataFirebase;
                                // print('Maplist : ${context.read<ProviderClass>().mapList}');
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          child: const Text(TStrings.submit),
                        ),
                      ],
                    );
                  },
                );
              });
        },
        icon: addTaskPlusIcon);
  }
}
