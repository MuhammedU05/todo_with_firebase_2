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
  DateTime selectedDate = DateTime.now();
  var editedDate =
      '${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}';
  @override
  void initState() {
    super.initState();
    selectedGroup = groups.isNotEmpty ? groups[0] : null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().month),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate
        // &&
        // picked.day > selectedDate.day &&
        // picked.year > selectedDate.year
        ) {
      setState(() {
        selectedDate = picked;
        editedDate =
            '${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      const Text(
        'Add Task',
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
            onPressed: () {
              selectedDate = DateTime.now();
              selectedPriority = 'Mid';
              selectedColor = Colors.yellow;
              toggleButtonsSelection[1] = true;
              toggleButtonsSelection[2] = false;
              toggleButtonsSelection[0] = false;
              print(FirebaseAuth.instance.currentUser);
              showBottomSheet(
                  // shape: BeveledRectangleBorder(),
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (BuildContext context) {
                    //To Change State of the AlertDialog
                    return SingleChildScrollView(child: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
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
                                  selectedColor = Colors.yellow;
                                  selectedPriority = 'Mid';
                                  print(selectedPriority);
                                } else if (value == 0) {
                                  toggleButtonsSelection[1] = false;
                                  toggleButtonsSelection[2] = false;
                                  toggleButtonsSelection[0] = true;
                                  selectedColor = Colors.red;
                                  selectedPriority = 'High';
                                  print(selectedPriority);
                                } else if (value == 2) {
                                  toggleButtonsSelection[1] = false;
                                  toggleButtonsSelection[2] = true;
                                  toggleButtonsSelection[0] = false;
                                  selectedColor = Colors.green;
                                  selectedPriority = 'Low';
                                  print(selectedPriority);
                                } else {
                                  selectedColor = Colors.yellow;
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              style: const ButtonStyle(),
                              onPressed: () {
                                taskNameController.clear();
                                Navigator.of(context).pop();
                              },
                              child: const Text(TStrings.cancel),
                            ),
                            const Spacer(),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: const Text('Select Date'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  if (taskNameController.text.isNotEmpty) {
                                    // setState(() async {
                                    context
                                        .read<FirebaseProviderClass>()
                                        .addFirebaseData(
                                          //Task Name
                                          taskNameController.text.toString(),
                                          //Created Time
                                          formatDate(
                                              DateTime.now(), [HH, ' : ', nn]),
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
                                          '',
                                          //Due To Date
                                          selectedDate,
                                          //Due To Date (Edited)
                                          editedDate,
                                        );

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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Durations.long2,
                                        elevation: 20,
                                        // shape: CircleBorder(),
                                        content: Text(
                                          'Task Added',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    // });
                                  }
                                } on Exception catch (e) {
                                  print('Add Task Submit Error : $e');
                                }
                              },
                              child: const Text('Submit'),
                            ),
                            const Spacer()
                          ],
                        ),
                      ]);
                    }));
                  });
            },
            icon: addTaskPlusIcon),
      ),
    ]);
  }
}


// import 'package:date_format/date_format.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
// import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
// import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
// import 'package:todo_with_firebase_2/Utils/variables.dart';

// class AddTask extends StatefulWidget {
//   const AddTask({Key? key}) : super(key: key);

//   @override
//   State<AddTask> createState() => _AddTaskState();
// }

// class _AddTaskState extends State<AddTask> {
//   late DateTime selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     selectedDate = DateTime.now();
//     selectedGroup = groups.isNotEmpty ? groups[0] : null;
//   }



//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         selectedPriority = 'Mid';
//         toggleButtonsSelection[1] = true;
//         toggleButtonsSelection[2] = false;
//         toggleButtonsSelection[0] = false;
//         print(FirebaseAuth.instance.currentUser);
//         showModalBottomSheet(
//           context: context,
//           backgroundColor: Colors.transparent,
//           builder: (BuildContext context) {
//             return Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: taskNameController,
//                     autofocus: true,
//                     decoration: const InputDecoration(
//                       labelText: TStrings.addTask,
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   DropdownButton<String>(
//                     value: selectedGroup,
//                     items: groups.map((group) {
//                       return DropdownMenuItem<String>(
//                         value: group,
//                         child: Text(group),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           selectedGroup = newValue;
//                         });
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   ToggleButtons(
//                     textStyle: const TextStyle(
//                         fontSize: 17, fontWeight: FontWeight.w500),
//                     splashColor: Colors.black45,
//                     fillColor: Colors.black54,
//                     borderWidth: 5,
//                     selectedBorderColor: Colors.black54,
//                     selectedColor: selectedColor,
//                     constraints: const BoxConstraints(
//                       minHeight: 32.0,
//                       minWidth: 56.0,
//                     ),
//                     onPressed: (int value) {
//                       setState(() {
//                         if (value == 1) {
//                           toggleButtonsSelection[1] = true;
//                           toggleButtonsSelection[2] = false;
//                           toggleButtonsSelection[0] = false;
//                           selectedPriority = 'Mid';
//                         } else if (value == 0) {
//                           toggleButtonsSelection[1] = false;
//                           toggleButtonsSelection[2] = false;
//                           toggleButtonsSelection[0] = true;
//                           selectedPriority = 'High';
//                         } else if (value == 2) {
//                           toggleButtonsSelection[1] = false;
//                           toggleButtonsSelection[2] = true;
//                           toggleButtonsSelection[0] = false;
//                           selectedPriority = 'Low';
//                         } else {
//                           selectedPriority = 'Mid';
//                         }
//                       });
//                     },
//                     isSelected: toggleButtonsSelection,
//                     children: priorityOptions
//                             .map(((Priority, String) priorityQ) =>
//                                 Text(priorityQ.$2))
//                             .toList()),
//                   const SizedBox(height: 16.0),
//                   Row(
//                     children: [
//                       const Spacer(),
//                       ElevatedButton(
//                         onPressed: () => _selectDate(context),
//                         child: const Text('Select Date'),
//                       ),
//                       const SizedBox(width: 16.0),
//                       ElevatedButton(
//                         onPressed: () async {
//                           if (taskNameController.text.isNotEmpty) {
//                             context
//                                 .read<FirebaseProviderClass>()
//                                 .addFirebaseData(
//                                   // Task Name
//                                   taskNameController.text.toString(),
//                                   // Created Time
//                                   formatDate(
//                                       DateTime.now(), [HH, ' : ', nn]),
//                                   // Created Date
//                                   formatDate(DateTime.now(),
//                                       [dd, ' - ', mm, ' - ', yy]),
//                                   // Selected Group
//                                   selectedGroup!,
//                                   // Selected Priority
//                                   selectedPriority!,
//                                   // Is Completed
//                                   false,
//                                   // Completed Date
//                                   '',
//                                   // Completed Time
//                                   '',
//                                 );

//                             print("Added");

//                             await context
//                                 .read<FirebaseProviderClass>()
//                                 .updateData();
//                             await context
//                                 .read<FirebaseProviderClass>()
//                                 .getFirebaseDatasCompleted();
//                             print("testing");
//                             taskNameController.clear();
//                             Navigator.of(context).pop();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 elevation: 20,
//                                 content: Text(
//                                   'Task Added',
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           }
//                         },
//                         child: const Text('Submit'),
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//       child: addTaskPlusIcon,
//     );
//   }
// }
