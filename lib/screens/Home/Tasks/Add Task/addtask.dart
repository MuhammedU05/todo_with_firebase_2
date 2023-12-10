// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  void initState() {
    super.initState();
    selectedGroup = groups.isNotEmpty ? groups[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          selectedPriority = 'Mid';
          toggleButtonsSelection[1] = true;
          toggleButtonsSelection[2] = false;
          toggleButtonsSelection[0] = false;
          print(FirebaseAuth.instance.currentUser);
          showBottomSheet(
            backgroundColor: Colors.grey.shade300,
              context: context,
              builder: (BuildContext context) {
                //To Change State of the AlertDialog
                return StatefulBuilder(
                    builder: (context, StateSetter setState) {
                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/1.7,
                      child: TextFormField(
                        controller: taskNameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: TStrings.addTask,
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedGroup,
                      items: groups.map((group) {
                        return DropdownMenuItem<String>(
                          value: group,
                          child: Text(group),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedGroup = newValue;
                          });
                        }
                      },
                    ),
                    // To Set Priority
                    ToggleButtons(
                        textStyle: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                        splashColor: Colors.black45,
                        fillColor: Colors.black54,
                        borderWidth: 5,
                        selectedBorderColor: Colors.black54,
                        selectedColor: selectedColor,
                        constraints: const BoxConstraints(
                          minHeight: 32.0,
                          minWidth: 56.0,
                        ),
                        onPressed: (int value) {
                          setState(() {
                            print(toggleButtonsSelection);
                            if (value == 1) {
                              toggleButtonsSelection[1] = true;
                              toggleButtonsSelection[2] = false;
                              toggleButtonsSelection[0] = false;
                              selectedPriority = 'Mid';
                              print(selectedPriority);
                            } else if (value == 0) {
                              toggleButtonsSelection[1] = false;
                              toggleButtonsSelection[2] = false;
                              toggleButtonsSelection[0] = true;
                              selectedPriority = 'High';
                              print(selectedPriority);
                            } else if (value == 2) {
                              toggleButtonsSelection[1] = false;
                              toggleButtonsSelection[2] = true;
                              toggleButtonsSelection[0] = false;
                              selectedPriority = 'Low';
                              print(selectedPriority);
                            } else {
                              selectedPriority = 'Mid';
                            }

                            print(toggleButtonsSelection);
                          });
                        },
                        isSelected: toggleButtonsSelection,
                        children: priorityOptions
                            .map(((Priority, String) priorityQ) =>
                                Text(priorityQ.$2))
                            .toList()),
                            const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            taskNameController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text(TStrings.cancel),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            if (taskNameController.text.isNotEmpty) {
                              setState(() async {
                                context
                                    .read<FirebaseProviderClass>()
                                    .addFirebaseData(
                                        //Task Name
                                        taskNameController.text.toString(),
                                        //Created Time
                                        formatDate(DateTime.now(), [HH, ' : ', nn]),
                                        //Created Date
                                        formatDate(DateTime.now(),
                                            [dd, ' - ', mm, ' - ', yy]),
                                        //Selected Group
                                        selectedGroup!,
                                        //Selected Priority
                                        selectedPriority!,
                                        //Is Completed
                                        false,
                                        //Completed Date
                                        '',
                                        //Completed Time
                                        '');
                        
                                print("Added");
                        
                                await context
                                    .read<FirebaseProviderClass>()
                                    .updateData();
                                await context
                                    .read<FirebaseProviderClass>()
                                    .getFirebaseDatasCompleted();
                                print("testing");
                                taskNameController.clear();
                                Navigator.of(context).pop();
                              });
                            }
                          }, child: const Text('Submit'),
                        ),
                        const Spacer()
                      ],
                    )
                  ]);
                });
              });
        },
        icon: addTaskPlusIcon);
  }
}
