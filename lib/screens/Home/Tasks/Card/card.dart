// ignore_for_file: avoid_print, void_checks, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/colors.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/custom/button.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/carddesign.dart';

//Card Class
class CardBuilder extends StatefulWidget {
  const CardBuilder({Key? key}) : super(key: key);

  @override
  State<CardBuilder> createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  late var getDataFirebase =
      context.read<FirebaseProviderClass>().getFirebaseDatas();
  var editedDate;
  late DateTime selectedDate;

  var priorityColor = Colors.white;

  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().dataFirebase;
    // context.read<FirebaseProviderClass>().checkFirebaseDataExist();
    Future.delayed(Duration.zero, () => taskNameController.clear());
    // taskNameController.clear();
    // selectedDate = tasks[TStrings.dueToFirebase];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        editedDate = '${picked.day} - ${picked.month} - ${picked.year}';
      });
      // } else {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(const SnackBar(content: Text('Please pick a Date')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mapList.isEmpty || mapList.length == 1) {
      getDataFirebase;
      return const Center(
        child: Text(TStrings.addTask),
      );
    }
    //Card
    return FutureBuilder(
        future: getDataFirebase,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
                'Loading Please Wait..'); // or some loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    shrinkWrap: true,
                    // reverse: true,
                    itemCount: mapList.length - 1,
                    itemBuilder: (context, index) {
                      print('Index : $index');
                      String taskName = mapList.keys.elementAt(index + 1);
                      Map<String, dynamic> task = mapList[taskName] ?? {};
                      if (task[TStrings.priority] == TStrings.mid) {
                        priorityColor = TColors.white;
                      } else if (task[TStrings.priority] == TStrings.low) {
                        priorityColor = TColors.green;
                      } else if (task[TStrings.priority] == TStrings.high) {
                        priorityColor = TColors.red;
                      } else {
                        priorityColor = TColors.white;
                      }
                      // selectedDate = task[TStrings.dueToFirebase] ?? DateTime.now();
                      //Tap using a GestureDetector
                      return GestureDetector(
                          onLongPress: () {
                            showBottomSheet(
                                backgroundColor: Colors.grey.shade200,
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 9,
                                    child: StatefulBuilder(
                                        builder: ((context, setState) {
                                      return Column(
                                        children: [
                                          const Text('You Want To Delete?',
                                              style: TextStyle(fontSize: 20)),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                90,
                                          ),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(TStrings.no),
                                              ),
                                              const Spacer(),
                                              ElevatedButton(
                                                onPressed: () {
                                                  print(task['TimeStamp']);
                                                  context
                                                      .read<
                                                          FirebaseProviderClass>()
                                                      .deleteTask(
                                                          task['TimeStamp']);
                                                  context
                                                      .read<
                                                          FirebaseProviderClass>()
                                                      .updateData();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(TStrings.yes),
                                              ),
                                              const Spacer(),
                                            ],
                                          )
                                        ],
                                      );
                                    })),
                                  );
                                });
                          },
                          onTap: () {
                            Timestamp convertedSelectedDate =
                                task[TStrings.dueToFirebase] ?? DateTime.now();
                            selectedDate = convertedSelectedDate.toDate();
                            // isCompletedSelected = false;
                            taskNameController.text =
                                task[TStrings.taskNameFirebase];
                            print(
                                'Priority on tap : ${task[TStrings.priorityFirebase]}');
                            print(
                                "$taskName \n  ${task[TStrings.createdDateFirebase]} \n ${task[TStrings.createdTimeFirebase]} \n ${task[TStrings.priorityFirebase]}");
                            if (task[TStrings.priorityFirebase] ==
                                TStrings.low) {
                              selectedPriority = TStrings.low;
                              selectedColor = Colors.green;
                              toggleButtonsSelection[2] = true;
                              toggleButtonsSelection[1] = false;
                              toggleButtonsSelection[0] = false;
                            } else if (task[TStrings.priorityFirebase] ==
                                TStrings.mid) {
                              selectedColor = Colors.yellow;
                              toggleButtonsSelection[0] = false;
                              toggleButtonsSelection[1] = true;
                              toggleButtonsSelection[2] = false;
                              selectedPriority = TStrings.mid;
                            } else if (task[TStrings.priorityFirebase] ==
                                TStrings.high) {
                              selectedColor = Colors.red;
                              toggleButtonsSelection[2] = false;
                              toggleButtonsSelection[1] = false;
                              toggleButtonsSelection[0] = true;
                              selectedPriority = TStrings.high;
                            }
                            showBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(TStrings.edit),
                                        TextFormField(
                                          controller: taskNameController,
                                          decoration: InputDecoration(
                                            labelText: TStrings.edit,
                                            icon: profileIcon,
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
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
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
                                              print(
                                                  'Priority on tap : ${task[TStrings.priorityFirebase]}');
                                              setState(() {
                                                print(toggleButtonsSelection);
                                                selectedPriority = task[
                                                    TStrings.priorityFirebase];

                                                if (value == 1) {
                                                  toggleButtonsSelection[1] =
                                                      true;
                                                  toggleButtonsSelection[2] =
                                                      false;
                                                  toggleButtonsSelection[0] =
                                                      false;
                                                  selectedColor = Colors.yellow;
                                                  selectedPriority = 'Mid';
                                                  print(
                                                      'Selected Priority :$selectedPriority');
                                                } else if (value == 0) {
                                                  toggleButtonsSelection[1] =
                                                      false;
                                                  toggleButtonsSelection[2] =
                                                      false;
                                                  toggleButtonsSelection[0] =
                                                      true;
                                                  selectedColor = Colors.red;
                                                  selectedPriority = 'High';
                                                  print(
                                                      'Selected Priority :$selectedPriority');
                                                } else if (value == 2) {
                                                  toggleButtonsSelection[1] =
                                                      false;
                                                  toggleButtonsSelection[2] =
                                                      true;
                                                  toggleButtonsSelection[0] =
                                                      false;
                                                  selectedColor = Colors.green;
                                                  selectedPriority = 'Low';
                                                  print(
                                                      'Selected Priority :$selectedPriority');
                                                } else {
                                                  selectedPriority = 'Mid';
                                                }

                                                print(toggleButtonsSelection);
                                              });
                                            },
                                            isSelected: toggleButtonsSelection,
                                            children: priorityOptions
                                                .map(((
                                                          Priority,
                                                          String
                                                        ) priorityQ) =>
                                                    Text(priorityQ.$2))
                                                .toList()),
                                        const CustomButtonCompleted(),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                taskNameController.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child:
                                                  const Text(TStrings.cancel),
                                            ),
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  _selectDate(context),
                                              child: const Text('Select Date'),
                                            ),
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                try {
                                                  print(task[TStrings
                                                      .timeStampFirebase]);

                                                  // Schedule the code to run after the build is complete
                                                  Future.delayed(Duration.zero,
                                                      () async {
                                                    // context
                                                    //     .read<
                                                    //         FirebaseProviderClass>()
                                                    //     .completeTask();
                                                    Navigator.of(context).pop();
                                                    context
                                                        .read<
                                                            FirebaseProviderClass>()
                                                        .updateMessage(
                                                          task[TStrings
                                                              .timeStampFirebase],
                                                          isCompletedSelected,
                                                          taskNameController
                                                              .text
                                                              .toString(),
                                                          selectedGroup ?? 'Me',
                                                          formatDate(
                                                              DateTime.now(), [
                                                            HH,
                                                            ' : ',
                                                            nn
                                                          ]), // Created Time
                                                          formatDate(
                                                              DateTime.now(), [
                                                            dd,
                                                            ' - ',
                                                            mm,
                                                            ' - ',
                                                            yy
                                                          ]), // Created Date
                                                          selectedPriority,
                                                          //Due To Date
                                                          selectedDate,
                                                          //Due To Date (Edited)
                                                          editedDate ??
                                                              task[
                                                                  'Edited DueDate'],
                                                        );
                                                    context
                                                        .read<
                                                            FirebaseProviderClass>()
                                                        .updateData();
                                                    // Navigator.of(context).pop();
                                                    textController.clear();
                                                  });
                                                } on Exception catch (e) {
                                                  print(
                                                      'Error Updating Task : $e');
                                                }
                                              },
                                              child:
                                                  const Text(TStrings.submit),
                                            ),
                                            const Spacer()
                                          ],
                                        )
                                      ]);
                                });
                              },
                            );
                          },
                          child: cardDesign(task));
                    }));
          }
        });
  }
}
