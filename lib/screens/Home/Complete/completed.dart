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
import 'package:firebase_auth/firebase_auth.dart';


// ignore_for_file: prefer_const_constructors


class TaskScreenCompleted extends StatefulWidget {
  const TaskScreenCompleted({super.key});

  @override
  State<TaskScreenCompleted> createState() => _TaskScreenCompletedState();
}

class _TaskScreenCompletedState extends State<TaskScreenCompleted> {
  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().dataFirebaseC;
    context.read<FirebaseProviderClass>().getFirebaseDatasCompleted();
    // context.read<ProviderClass>().addFirebaseDataFirst();    
    print(
        'Photo URL : ${FirebaseAuth.instance.currentUser?.photoURL?.toString()}');
    print('Display Name : ${FirebaseAuth.instance.currentUser?.displayName}');
    print('Current User In Task : ${FirebaseAuth.instance.currentUser}');
  }

  @override
  Widget build(BuildContext context) {
    // Use the watch method from context to access the ProviderClass
    FirebaseProviderClass provider = context.watch<FirebaseProviderClass>();
    // bool isLoading = provider.isLoading;

    // return Column(
    //   children: [
    //     _buildTextComposer(),
    return isLoadingCompleted
        // ? CircularProgressIndicator() // Show a loading indicator while data is being retrieved
        ? Text('Loading Please wait...')
        : CompletedCardBuilder();
    // const SizedBox(height: 16),

    //   ],
    // );
  }
}




//Card Class
class CompletedCardBuilder extends StatefulWidget {
  const CompletedCardBuilder({Key? key}) : super(key: key);

  @override
  State<CompletedCardBuilder> createState() => _CompletedCardBuilderState();
}

class _CompletedCardBuilderState extends State<CompletedCardBuilder> {
  late var getDataFirebaseC =
      context.read<FirebaseProviderClass>().getFirebaseDatasCompleted();

  var priorityColor = Colors.white;
  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().dataFirebaseC;
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

    if (mapListCompleted.length <= 1) {
      return const Center(
        child: Text(TStrings.notCompleted),
      );
    }
    //Card
    return FutureBuilder(
        // initialData: context.read<FirebaseProviderClass>().checkFirebaseDataExist(),
        future: getDataFirebaseC,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Consumer<ProviderClass>(
              builder: (BuildContext context, snapshot, Widget? child) =>
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // reverse: true,
                      itemCount: mapListCompleted.length - 1,
                      // itemCount: provider.mapList.length.clamp(0, double.infinity).toInt(),
                      itemBuilder: (context, index) {
                        print('Index : $index');
                        String taskName = mapListCompleted.keys.elementAt(index + 1);
                        Map<String, dynamic> task = mapListCompleted[taskName] ?? {};
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
                        return Card(
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
                        );
                      },
                    ),
                  ));
        });
  }
}
// class CompletedCardBuilder extends StatefulWidget {
//   const CompletedCardBuilder({Key? key}) : super(key: key);

//   @override
//   State<CompletedCardBuilder> createState() => _CompletedCardBuilderState();
// }

// class _CompletedCardBuilderState extends State<CompletedCardBuilder> {
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
