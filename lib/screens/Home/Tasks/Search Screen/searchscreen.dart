// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class SearchClass extends StatefulWidget {
  const SearchClass({super.key});

  @override
  State<SearchClass> createState() => _SearchClassState();
}

class _SearchClassState extends State<SearchClass> {
  late String changedText;

  @override
  void initState() {
    super.initState();
    changedText = '';
    textControllerSearch.text = ' ';
  }

//f8217500-e743-1e06-95da-57f3c2a5882a
//34de6db0-e78d-1e06-ad33-2be5425785c4

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        textControllerSearch.clear();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(children: <Widget>[
              const SizedBox(width: 10.0),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    autofocus: true,
                    controller: textControllerSearch,
                    onChanged: (changedValue) {
                      setState(() {
                        changedText = changedValue.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // IconButton(
              //   iconSize: 35,
              //   icon: Icon(MdiIcons.filter),
              //   onPressed: () {
              //     Builder(builder: ((context) {
              //       return
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  icon: Icon(MdiIcons.filter),
                  iconSize: 35,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.black,
                  items: <String>[
                    'Task Name',
                    // 'Created Date',
                    'Priority',
                    'Assign To'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                      onTap: () {
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                    );
                  }).toList(),
                  value: dropdownValue,
                  onChanged: (val) {
                    dropdownValue = val!;
                    print(val);
                  },
                  //       );
                  //     }
                ),
              )
              // );
              //   },
              // )
            ]),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(firebaseAuthInstance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data?.data() as Map<String, dynamic>?;

            if (data == null) {
              return const Center(
                child: Text('No data found'),
              );
            }

            // Assuming you have two lists named 'list1' and 'list2'
            var list1 = data['Completed Tasks'] as List? ?? [];
            var list2 = data['Tasks'] as List? ?? [];

            list1.removeWhere(
                (element) => element['Task Name'] == 'First Created');
            list2.removeWhere(
                (element) => element['Task Name'] == 'First Created');

            // Combine list1 and list2
            var combinedList = List.from(list1)..addAll(list2);

            // Filter combinedList based on the search text
            var filteredList = combinedList
                .where((item) => item[dropdownValue]
                    .toString()
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .startsWith(changedText.toLowerCase().replaceAll(' ', '')))
                .toList();
            print('Filtered List : $filteredList');
            if (filteredList.isEmpty) {
              print('true');
              filteredList = combinedList
                  .where((item) => item[dropdownValue]
                      .toString()
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(changedText.toLowerCase().replaceAll(' ', '')))
                  .toList();
              print('Filtered List : $filteredList');
            }
            // You can display the filtered list as needed
            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: const Color.fromARGB(255, 237, 232, 232),
                    elevation: 2,
                    child: SizedBox(
                      height: 55,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              filteredList[index][TStrings.taskNameFirebase],
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(filteredList[index]
                                    [TStrings.isCompletedFirebase]
                                ? 'Completed'
                                : 'Not Completed'),
                          )
                          // trailing: Text(
                          //     filteredList[index][TStrings.isCompletedFirebase])
                          // Text(filteredList[index][TStrings.isCompletedFirebase]),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String dropdownValue = 'Task Name';

  // Widget buildList(List<dynamic> items) {
  //   return ListView.builder(
  //     itemCount: items.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         title: Text(
  //           items[index].toString(),
  //           style: const TextStyle(
  //             color: Colors.black54,
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

// List<String>  = ['A', 'B', 'C', 'D'];
// const List<String> _locations = <String>[
//   'Task Name',
//   'Date',
//   'Priority',
//   'Assigned To'
// ];

// class DropdownMenuItemFilter extends StatefulWidget {
//   const DropdownMenuItemFilter({super.key});

//   @override
//   State<DropdownMenuItemFilter> createState() => _DropdownMenuItemFilterState();
// }

// class _DropdownMenuItemFilterState extends State<DropdownMenuItemFilter> {

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<String>(
//       initialSelection: list.first,
//       onSelected: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
//         return DropdownMenuEntry<String>(value: value, label: value);
//       }).toList(),
//     );
//   }
// }
// leading: CircleAvatar(
//   backgroundImage: NetworkImage(data['image']),
// ),

// body: SizedBox(
//     height: double.infinity,
//     child:
//         //Card
//         FutureBuilder(
//             future: getDataFirebase,
//             builder:
//                 (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               return SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       // reverse: true,
//                       itemCount: mapListCompleted.length - 1,
//                       itemBuilder: (context, index) {
//                         print('Index : $index');
//                         String taskName = mapListCompleted.keys.elementAt(index + 1);
//                         Map<String, dynamic> task = mapListCompleted[taskName] ?? {};
//                         if (task[TStrings.priority] == TStrings.mid) {
//                           priorityColor = TColors.white;
//                         } else if (task[TStrings.priority] ==
//                             TStrings.low) {
//                           priorityColor = TColors.green;
//                         } else if (task[TStrings.priority] ==
//                             TStrings.high) {
//                           priorityColor = TColors.red;
//                         } else {
//                           priorityColor = TColors.white;
//                         }
//                         //Tap using a GestureDetector
//                         return GestureDetector(
//                             onLongPress: () {
//                               showBottomSheet(
//                                   backgroundColor: Colors.grey.shade200,
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return SizedBox(
//                                       height: MediaQuery.of(context)
//                                               .size
//                                               .height /
//                                           9,
//                                       child: StatefulBuilder(
//                                           builder: ((context, setState) {
//                                         return Column(
//                                           children: [
//                                             const Text(
//                                                 'You Want To Delete?',
//                                                 style: TextStyle(
//                                                     fontSize: 20)),
//                                             SizedBox(
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .height /
//                                                   90,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 const Spacer(),
//                                                 ElevatedButton(
//                                                   onPressed: () {
//                                                     Navigator.of(context)
//                                                         .pop();
//                                                   },
//                                                   child: const Text(
//                                                       TStrings.no),
//                                                 ),
//                                                 const Spacer(),
//                                                 ElevatedButton(
//                                                   onPressed: () {
//                                                     print(
//                                                         task['TimeStamp']);
//                                                     context
//                                                         .read<
//                                                             FirebaseProviderClass>()
//                                                         .deleteTask(task[
//                                                             'TimeStamp']);
//                                                     context
//                                                         .read<
//                                                             FirebaseProviderClass>()
//                                                         .updateData();
//                                                     Navigator.of(context)
//                                                         .pop();
//                                                   },
//                                                   child: const Text(
//                                                       TStrings.yes),
//                                                 ),
//                                                 const Spacer(),
//                                               ],
//                                             )
//                                           ],
//                                         );
//                                       })),
//                                     );
//                                   });
//                             },
//                             onTap: () {
//                               isCompletedSelected = false;
//                               taskNameController.text = task['Task Name'];
//                               print(
//                                   'Priority on tap : ${task[TStrings.priorityFirebase]}');
//                               print(
//                                   "$taskName \n  ${task[TStrings.createdDateFirebase]} \n ${task[TStrings.createdTimeFirebase]} \n ${task[TStrings.priorityFirebase]}");
//                               if (task[TStrings.priorityFirebase] ==
//                                   TStrings.low) {
//                                 selectedPriority = TStrings.low;
//                                 toggleButtonsSelection[2] = true;
//                                 toggleButtonsSelection[1] = false;
//                                 toggleButtonsSelection[0] = false;
//                               } else if (task[TStrings.priorityFirebase] ==
//                                   TStrings.mid) {
//                                 toggleButtonsSelection[0] = false;
//                                 toggleButtonsSelection[1] = true;
//                                 toggleButtonsSelection[2] = false;
//                                 selectedPriority = TStrings.mid;
//                               } else if (task[TStrings.priorityFirebase] ==
//                                   TStrings.high) {
//                                 toggleButtonsSelection[2] = false;
//                                 toggleButtonsSelection[1] = false;
//                                 toggleButtonsSelection[0] = true;
//                                 selectedPriority = TStrings.high;
//                               }
//                               showBottomSheet(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return StatefulBuilder(builder:
//                                       (context, StateSetter setState) {
//                                     return Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           const Text(TStrings.edit),
//                                           TextFormField(
//                                             controller: taskNameController,
//                                             decoration: InputDecoration(
//                                               labelText: TStrings.edit,
//                                               icon: profileIcon,
//                                             ),
//                                           ),
//                                           DropdownButton<String>(
//                                             value: selectedGroup,
//                                             items: groups.map((group) {
//                                               return DropdownMenuItem<
//                                                   String>(
//                                                 value: group,
//                                                 child: Text(group),
//                                               );
//                                             }).toList(),
//                                             onChanged: (String? newValue) {
//                                               if (newValue != null) {
//                                                 setState(() {
//                                                   selectedGroup = newValue;
//                                                 });
//                                               }
//                                             },
//                                           ),
//                                           // To Set Priority
//                                           ToggleButtons(
//                                               textStyle: const TextStyle(
//                                                   fontSize: 17,
//                                                   fontWeight:
//                                                       FontWeight.w500),
//                                               splashColor: Colors.black45,
//                                               fillColor: Colors.black54,
//                                               borderWidth: 5,
//                                               selectedBorderColor:
//                                                   Colors.black54,
//                                               selectedColor: selectedColor,
//                                               constraints:
//                                                   const BoxConstraints(
//                                                 minHeight: 32.0,
//                                                 minWidth: 56.0,
//                                               ),
//                                               onPressed: (int value) {
//                                                 print(
//                                                     'Priority on tap : ${task[TStrings.priorityFirebase]}');
//                                                 setState(() {
//                                                   print(
//                                                       toggleButtonsSelection);
//                                                   selectedPriority = task[
//                                                       TStrings
//                                                           .priorityFirebase];

//                                                   if (value == 1) {
//                                                     toggleButtonsSelection[
//                                                         1] = true;
//                                                     toggleButtonsSelection[
//                                                         2] = false;
//                                                     toggleButtonsSelection[
//                                                         0] = false;
//                                                     selectedPriority =
//                                                         'Mid';
//                                                     print(
//                                                         'Selected Priority :$selectedPriority');
//                                                   } else if (value == 0) {
//                                                     toggleButtonsSelection[
//                                                         1] = false;
//                                                     toggleButtonsSelection[
//                                                         2] = false;
//                                                     toggleButtonsSelection[
//                                                         0] = true;
//                                                     selectedPriority =
//                                                         'High';
//                                                     print(
//                                                         'Selected Priority :$selectedPriority');
//                                                   } else if (value == 2) {
//                                                     toggleButtonsSelection[
//                                                         1] = false;
//                                                     toggleButtonsSelection[
//                                                         2] = true;
//                                                     toggleButtonsSelection[
//                                                         0] = false;
//                                                     selectedPriority =
//                                                         'Low';
//                                                     print(
//                                                         'Selected Priority :$selectedPriority');
//                                                   } else {
//                                                     selectedPriority =
//                                                         'Mid';
//                                                   }

//                                                   print(
//                                                       toggleButtonsSelection);
//                                                 });
//                                               },
//                                               isSelected:
//                                                   toggleButtonsSelection,
//                                               children: priorityOptions
//                                                   .map(((
//                                                             Priority,
//                                                             String
//                                                           ) priorityQ) =>
//                                                       Text(priorityQ.$2))
//                                                   .toList()),
//                                           const CustomButtonCompleted(),
//                                           Row(
//                                             children: [
//                                               const Spacer(),
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   taskNameController
//                                                       .clear();
//                                                   Navigator.of(context)
//                                                       .pop();
//                                                 },
//                                                 child: const Text(
//                                                     TStrings.cancel),
//                                               ),
//                                               const Spacer(),
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   print(task['TimeStamp']);
//                                                   context
//                                                       .read<
//                                                           FirebaseProviderClass>()
//                                                       .completeTask();
//                                                   context
//                                                       .read<
//                                                           FirebaseProviderClass>()
//                                                       .updateMessage(
//                                                           task['TimeStamp'],
//                                                           isCompletedSelected,
//                                                           taskNameController
//                                                               .text,
//                                                           selectedGroup ??
//                                                               'Me',
//                                                           //Created Time
//                                                           formatDate(
//                                                               DateTime.now(),
//                                                               [
//                                                                 HH,
//                                                                 ' : ',
//                                                                 nn
//                                                               ]),
//                                                           //Created Date
//                                                           formatDate(
//                                                               DateTime
//                                                                   .now(),
//                                                               [
//                                                                 dd,
//                                                                 ' - ',
//                                                                 mm,
//                                                                 ' - ',
//                                                                 yy
//                                                               ]),
//                                                           selectedPriority);

//                                                   context
//                                                       .read<
//                                                           FirebaseProviderClass>()
//                                                       .updateData();
//                                                   Navigator.of(context)
//                                                       .pop();
//                                                   textController.clear();
//                                                 },
//                                                 child: const Text(
//                                                     TStrings.submit),
//                                               ),
//                                               const Spacer()
//                                             ],
//                                           )
//                                         ]);
//                                   });
//                                 },
//                               );
//                             },
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               elevation: 10,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: TColors.theme,
//                                 ),
//                                 // color: TColors.theme,
//                                 width: double.maxFinite,
//                                 height: 200,
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               1.3,
//                                           child: Text(
//                                             '${TStrings.taskName} :\n  ${task[TStrings.taskName] ?? TStrings.na}',
//                                             textAlign: TextAlign.left,
//                                             softWrap: true,
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 4,
//                                             style: TextStyle(
//                                               fontSize: 25,
//                                               color: TColors.white,
//                                               fontWeight: FontWeight.w800,
//                                             ),
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                           children: [
//                                             Text(
//                                               '${TStrings.createdOn}\n ${task[TStrings.createdTimeFirebase] ?? TStrings.na}',
//                                               textAlign: TextAlign.right,
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: TColors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           '${TStrings.priority} : ${task[TStrings.priorityFirebase]}',
//                                           textAlign: TextAlign.left,
//                                           style: TextStyle(
//                                             fontSize: 25,
//                                             color: priorityColor,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         SizedBox(
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                   task['Is Completed'] ==
//                                                           false
//                                                       ? TStrings
//                                                           .notCompleted
//                                                       : TStrings.completed,
//                                                   softWrap: true,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: TextStyle(
//                                                       color: TColors.green,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 20)),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     // LinearProgressIndicator(color: Colors.green,minHeight: 5,)
//                                   ],
//                                 ),
//                               ),
//                             ));
//                       }));
//             })
// ),
//     );
//   }
// }
//   }
// }
