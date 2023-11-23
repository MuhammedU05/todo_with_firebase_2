import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController groupAddingController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  late List items;

  String? _selectedItem = 'Add Group';
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: taskNameController,
                      decoration: const InputDecoration(
                        labelText: "Task Name",
                        icon: Icon(Icons.account_box),
                      ),
                    ),
                    DropdownButton(
                      value: _selectedItem,
                      items: items.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // Use a nullable type for onChanged
                        if (newValue != null) {
                          _selectedItem = newValue.toString();
                        }
                      },
                    ),
                    // DropdownButton<String>(
                    //   value: selectedItem,
                    //   items: items.map((item) {
                    //     return DropdownMenuItem<String>(
                    //       value: item,
                    //       child: Text(item),
                    //     );
                    //   }).toList(),
                    //   onChanged: (String? newValue) {
                    //     // Use a nullable type for onChanged
                    //     if (newValue != null) {
                    //       selectedItem = newValue;
                    //     }
                    //   },
                    // ),
                  ],
                ),
                actions: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text('Cancel'),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the selected item here
                      if (_selectedItem != null) {
                        print('Selected item: $_selectedItem');
                      }
                      context.read<ProviderClass>().addTask();
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
              // AlertDialog(
              //   scrollable: true,
              //   title: const Text("Add Task"),
              //   content: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Form(
              //       child: Column(
              //         children: [
              //           TextFormField(
              //             controller: taskNameController,
              //             decoration: const InputDecoration(
              //               labelText: "Task Name",
              //               icon: Icon(Icons.account_box),
              //             ),
              //           ),
              //           TextFormField(
              //             controller: groupAddingController,
              //             decoration: const InputDecoration(
              //               labelText: "Group",
              //               icon: Icon(Icons.email),
              //             ),
              //           ),
              //           // TextFormField(
              //           //   decoration: const InputDecoration(
              //           //     labelText: "Members",
              //           //     icon: Icon(Icons.message),
              //           //   ),
              //           // ),

              //           // DropdownButton(
              //           //   onTap: () {},
              //           //   icon: const Icon(Icons.priority_high),
              //           //   items: const [
              //           //     DropdownMenuItem(child: Text('High')),
              //           //     DropdownMenuItem(child: Text('Mid')),
              //           //     DropdownMenuItem(child: Text('Low')),
              //           //   ],
              //           //   onChanged: (value) {
              //           //     priorityController.text = value;
              //           //   },
              //           //   hint: const Text('Select Priority'),
              //           //   value: priorityController.text.isNotEmpty ? priorityController.text : null,
              //           // ),

              //           // DropdownButton(
              //           //   onChanged: (i) {
              //           //     setState(() {});
              //           //   },
              //           //   items: [],
              //           // ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   actions: [
              //     ElevatedButton(
              //       child: const Text("submit"),
              //       onPressed: () {
              //         firebaseFirestore.collection('Tasks').doc().set({
              //           'TaskName': taskNameController.text,
              //           'Group': groupAddingController.value,
              //           'Members': [],
              //           'Priority': priorityController.text,
              //         });
              //         Navigator.of(context).pop();
              //       },
              //     ),
              //   ],
              // );
            });
      },
      icon: Icon(
        Icons.add_circle,
        size: 70,
      ),
    );
  }
}
