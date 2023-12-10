// ignore_for_file: avoid_print, void_checks
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/colors.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/Utils/custom/button.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/task.dart';

//Card Class
class CardBuilder extends StatefulWidget {
  const CardBuilder({Key? key}) : super(key: key);

  @override
  State<CardBuilder> createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  late var getDataFirebase =
      context.read<FirebaseProviderClass>().getFirebaseDatas();

  var priorityColor = Colors.white;
  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().dataFirebase;
    context.read<FirebaseProviderClass>().checkFirebaseDataExist();
    taskNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // var provider = context.watch<ProviderClass>();

    //If Contition for checking the data is loading or not
    // if (isLoading) {
    //   return const Center(
    //     // child: CircularProgressIndicator(),
    //     child: Text('error'),
    //   );
    // }

    if (mapList.length <= 1) {
      return const Center(
        child: Text(TStrings.addTask),
      );
    }
    //Card
    return FutureBuilder(
        // initialData: context.read<FirebaseProviderClass>().checkFirebaseDataExist(),
        future: getDataFirebase,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Consumer<ProviderClass>(
              builder: (BuildContext context, snapshot, Widget? child) =>
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // reverse: true,
                      itemCount: mapList.length - 1,
                      // itemCount: provider.mapList.length.clamp(0, double.infinity).toInt(),
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
                        //Tap using a GestureDetector
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('You Want To Delete?'),
                                      actions: [
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
                                                .read<FirebaseProviderClass>()
                                                .deleteTask(task['TimeStamp']);

                                            context
                                                .read<FirebaseProviderClass>()
                                                .updateData();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(TStrings.yes),
                                        ),
                                      ]);
                                });
                          },
                          onTap: () {
                            isCompletedSelected = false;
                            taskNameController.text = task['Task Name'];
                            print(
                                'Priority on tap : ${task[TStrings.priorityFirebase]}');
                            print(
                                "$taskName \n  ${task[TStrings.createdDateFirebase]} \n ${task[TStrings.createdTimeFirebase]} \n ${task[TStrings.priorityFirebase]}");
                            if (task[TStrings.priorityFirebase] ==
                                TStrings.low) {
                              selectedPriority = TStrings.low;
                              toggleButtonsSelection[2] = true;
                              toggleButtonsSelection[1] = false;
                              toggleButtonsSelection[0] = false;
                            } else if (task[TStrings.priorityFirebase] ==
                                TStrings.mid) {
                              toggleButtonsSelection[0] = false;
                              toggleButtonsSelection[1] = true;
                              toggleButtonsSelection[2] = false;
                              selectedPriority = TStrings.mid;
                            } else if (task[TStrings.priorityFirebase] ==
                                TStrings.high) {
                              toggleButtonsSelection[2] = false;
                              toggleButtonsSelection[1] = false;
                              toggleButtonsSelection[0] = true;
                              selectedPriority = TStrings.high;
                            }
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return AlertDialog(
                                      title: const Text(TStrings.edit),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
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
                                              selectedBorderColor:
                                                  Colors.black54,
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
                                                      TStrings
                                                          .priorityFirebase];

                                                  if (value == 1) {
                                                    toggleButtonsSelection[1] =
                                                        true;
                                                    toggleButtonsSelection[2] =
                                                        false;
                                                    toggleButtonsSelection[0] =
                                                        false;
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
                                                    selectedPriority = 'Low';
                                                    print(
                                                        'Selected Priority :$selectedPriority');
                                                  } else {
                                                    selectedPriority = 'Mid';
                                                  }

                                                  print(toggleButtonsSelection);
                                                });
                                              },
                                              isSelected:
                                                  toggleButtonsSelection,
                                              children: priorityOptions
                                                  .map(((
                                                            Priority,
                                                            String
                                                          ) priorityQ) =>
                                                      Text(priorityQ.$2))
                                                  .toList()),
                                          const CustomButtonCompleted()
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
                                            print(task['TimeStamp']);
                                            context
                                                .read<FirebaseProviderClass>()
                                                .completeTask();
                                              context
                                                  .read<FirebaseProviderClass>()
                                                  .updateMessage(
                                                      task['TimeStamp'],
                                                      isCompletedSelected,
                                                      taskNameController.text,
                                                      selectedGroup ?? 'Me',
                                                      //Created Time
                                                      formatDate(DateTime.now(),
                                                          [HH, ' : ', nn]),
                                                      //Created Date
                                                      formatDate(
                                                          DateTime.now(), [
                                                        dd,
                                                        ' - ',
                                                        mm,
                                                        ' - ',
                                                        yy
                                                      ]),
                                                      selectedPriority);
                                            

                                            context
                                                .read<FirebaseProviderClass>()
                                                .updateData();
                                            Navigator.of(context).pop();
                                            textController.clear();
                                          },
                                          child: const Text(TStrings.submit),
                                        ),
                                      ],
                                    );
                                  });
                                });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: TColors.theme,
                              ),
                              // color: TColors.theme,
                              width: double.maxFinite,
                              height: 200,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        child: Text(
                                          '${TStrings.taskName} :\n  ${task[TStrings.taskName] ?? TStrings.na}',
                                          textAlign: TextAlign.left,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: TColors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${TStrings.createdOn}\n ${task[TStrings.createdTimeFirebase] ?? TStrings.na}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: TColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        '${TStrings.priority} : ${task[TStrings.priorityFirebase]}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: priorityColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        child: Column(
                                          children: [
                                            Text(
                                                task['Is Completed'] == false
                                                    ? TStrings.notCompleted
                                                    : TStrings.completed,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: TColors.green,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20)),
                                            // Text(
                                            //   TStrings.tNotCompleted,
                                            //   style: TextStyle(color: TColors.green),
                                            //   // icon: completed,
                                            //   // iconSize: 40,
                                            // ),
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
                  ));
        });
  }
}
// class CardBuilder extends StatefulWidget {
//   const CardBuilder({Key? key}) : super(key: key);

//   @override
//   State<CardBuilder> createState() => _CardBuilderState();
// }

// class _CardBuilderState extends State<CardBuilder> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//     // Perform tasks after the frame is built
//     context.read<ProviderClass>().dataFirebase;
//   });
//   }
//   @override
//   Widget build(BuildContext context) {
//     var provider = context.watch<ProviderClass>();
//      var priorityColor = Colors.white;

//     if (provider.isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (provider.mapList.isEmpty) {
//       return const Center(
//         child: Text(TStrings.addTask),
//       );
//     }

//     return FutureBuilder(
//         future: context.read<ProviderClass>().getFirebaseDatas(),
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('Error loading data'),
//             );
//           }

//           return SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: ListView.builder(
//               shrinkWrap: true,
//               // reverse: true,
//               itemCount: provider.mapList.length,
//               itemBuilder: (context, index) {
//                 String taskName = provider.mapList.keys.elementAt(index);
//                 Map<String, dynamic> task = provider.mapList[taskName] ?? {};
//                 if (task[TStrings.priority] == TStrings.mid) {
//                   priorityColor = TColors.white;
//                 } else if (task[TStrings.priority] == TStrings.low) {
//                   priorityColor = TColors.green;
//                 } else if (task[TStrings.priority] == TStrings.high) {
//                   priorityColor = TColors.red;
//                 } else {
//                   priorityColor = TColors.white;
//                 }
//                 //Tap using a GestureDetector
//                 return GestureDetector(
//                   onTap: () {
//                     print(
//                         "$taskName \n  ${task[TStrings.createdDateFirebase]} \n ${task[TStrings.createdTimeFirebase]}");
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return StatefulBuilder(
//                               builder: (context, StateSetter setState) {
//                             return AlertDialog(
//                               content: const Text('${TStrings.completed} ?'),
//                               actions: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     context
//                                         .read<ProviderClass>()
//                                         .updateMessage(task['TimeStamp'], true);
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text(TStrings.cancel),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text(TStrings.submit),
//                                 ),
//                               ],
//                             );
//                           });
//                         });
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 10,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: TColors.theme,
//                       ),
//                       // color: TColors.theme,
//                       width: double.maxFinite,
//                       height: 200,
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 '${TStrings.taskName} :\n  ${task[TStrings.taskName] ?? TStrings.na}',
//                                 textAlign: TextAlign.left,
//                                 style: TextStyle(
//                                   fontSize: 25,
//                                   color: TColors.white,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     '${TStrings.createdOn} ',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: TColors.white,
//                                     ),
//                                   ),
//                                   Text(
//                                     task[TStrings.createdTimeFirebase] ??
//                                         TStrings.na,
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: TColors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const Spacer(),
//                           Row(
//                             children: [
//                               Text(
//                                 '${TStrings.priority} : ${task[TStrings.priorityFirebase]}',
//                                 textAlign: TextAlign.left,
//                                 style: TextStyle(
//                                   fontSize: 25,
//                                   color: priorityColor,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               const Spacer(),
//                               SizedBox(
//                                 child: Column(
//                                   children: [
//                                     Text(TStrings.notCompleted,
//                                         softWrap: true,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                             color: TColors.green,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 20)),
//                                     // Text(
//                                     //   TStrings.tNotCompleted,
//                                     //   style: TextStyle(color: TColors.green),
//                                     //   // icon: completed,
//                                     //   // iconSize: 40,
//                                     // ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         });
//   }
// }
