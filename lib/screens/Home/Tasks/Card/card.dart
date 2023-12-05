// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/colors.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';

//Card Class
class CardBuilder extends StatefulWidget {
  const CardBuilder({Key? key}) : super(key: key);

  @override
  State<CardBuilder> createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  late var getDataFirebase = context.read<ProviderClass>().getFirebaseDatas();

  var priorityColor = Colors.white;
  @override
  void initState() {
    super.initState();
    context.read<ProviderClass>().dataFirebase;
    context.read<ProviderClass>().checkFirebaseDataExist();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ProviderClass>();

    //If Contition for checking the data is loading or not
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.mapList.isEmpty) {
      return const Center(
        child: Text(TStrings.addTask),
      );
    }
    //Card
    return FutureBuilder(
        future: getDataFirebase,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Consumer<ProviderClass>(
              builder: (BuildContext context, snapshot, Widget? child) =>
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // reverse: true,
                      itemCount: snapshot.mapList.length - 1,
                      itemBuilder: (context, index) {
                        String taskName =
                            snapshot.mapList.keys.elementAt(index + 1);
                        Map<String, dynamic> task =
                            snapshot.mapList[taskName] ?? {};
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
                          onTap: () {
                            print(
                                "$taskName \n  ${task[TStrings.createdDateFirebase]} \n ${task[TStrings.createdTimeFirebase]}");
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return AlertDialog(
                                      content:
                                          const Text('${TStrings.completed} ?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(TStrings.cancel),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            print(task['TimeStamp']);
                                            context
                                                .read<ProviderClass>()
                                                .updateMessage(
                                                    task['TimeStamp'], true);
                                            Navigator.of(context).pop();
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
                                      Text(
                                        '${TStrings.taskName} :\n  ${task[TStrings.taskName] ?? TStrings.na}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: TColors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${TStrings.createdOn} ',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: TColors.white,
                                            ),
                                          ),
                                          Text(
                                            task[TStrings
                                                    .createdTimeFirebase] ??
                                                TStrings.na,
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
                                            Text(TStrings.notCompleted,
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
