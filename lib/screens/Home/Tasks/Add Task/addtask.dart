import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskNameController = TextEditingController();
  late List<String> groups = ['Me'];
  final List<String> priority = ['Low', 'Mid', 'High'];
  late String? _selectedGroup;
  var _selectedPriority;
  String time = formatDate(DateTime.now(), [HH, ' : ', nn]);
  String date = formatDate(DateTime.now(), [dd, ' - ', mm, ' - ', yy]);

  @override
  void initState() {
    super.initState();
    _selectedGroup = groups.isNotEmpty ? groups[0] : null;
    _selectedPriority = priority.isNotEmpty ? priority[1] : null;
  }

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
                  DropdownButton<String>(
                    value: _selectedPriority,
                    items: priority.map((priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (String? newPriority) {
                      if (newPriority != null) {
                        _selectedPriority = newPriority;
                        setState(() {
                          
                          // print(grou)
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (taskNameController.text.isNotEmpty) {
                      setState(() {
                        context.read<ProviderClass>().addFirebaseData(
                            taskNameController.text.toString(),
                            formatDate(DateTime.now(), [HH, ' : ', nn]),
                            formatDate(
                                DateTime.now(), [dd, ' - ', mm, ' - ', yy]),
                            _selectedGroup!,
                            _selectedPriority!
                            // priority
                            );
                        
                        print("Added");
                        context.read<ProviderClass>().getFirebaseDatas();
                        // context.read<ProviderClass>().notifyListeners();

                        print("testing");
                        taskNameController.clear();
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(
        Icons.add_circle,
        color: Colors.black,
        size: 55,
      ),
    );
  }
}
