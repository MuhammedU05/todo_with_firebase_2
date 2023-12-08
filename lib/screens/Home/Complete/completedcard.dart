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
class CompletedCardBuilder extends StatefulWidget {
  const CompletedCardBuilder({Key? key}) : super(key: key);

  @override
  State<CompletedCardBuilder> createState() => _CompletedCardBuilderState();
}

class _CompletedCardBuilderState extends State<CompletedCardBuilder> {
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


    if (mapListCompleted.isEmpty || mapListCompleted.length == 1) {
      context.read<FirebaseProviderClass>().updateData();
      return const Center(
        child: Text(TStrings.addTask),
      );
    }
    //Card
    return FutureBuilder(
        // initialData: context.read<FirebaseProviderClass>().checkFirebaseDataExist(),
        future: getDataFirebase,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // reverse: true,
                      itemCount: mapListCompleted.length - 1,
                      // itemCount: provider.mapListCompleted.length.clamp(0, double.infinity).toInt(),
                      itemBuilder: (context, index) {
                        print('Index : $index');
                        String taskName = mapListCompleted.keys.elementAt(index + 1);
                        Map<String, dynamic> task = mapListCompleted[taskName] ?? {};
                        if (task[TStrings.priority] == TStrings.mid) {
                          priorityColor = TColors.white;
                        } else if (task[TStrings.priority] == TStrings.low) {
                          priorityColor = Colors.green.shade900;
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
                              color: TColors.greenTheme,
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
                                            TStrings.completed,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: TColors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20)),
                        
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
                  );
        });
  }
}