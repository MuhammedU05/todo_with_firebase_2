// ignore_for_file: avoid_print, void_checks
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/colors.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/carddesign.dart';

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
    context.read<FirebaseProviderClass>().dataFirebaseC;

    return isLoadingCompleted
        // ? CircularProgressIndicator() // Show a loading indicator while data is being retrieved
        ? Text('Loading Please wait...')
        : CompletedCardBuilder();
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
    // context.read<FirebaseProviderClass>().checkFirebaseDataExist();
    taskNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (mapListCompleted.length <= 1) {
      return const Center(
        child: Text(CONSTANTS.notCompleted),
      );
    }
    //Card
    return FutureBuilder(
        future: getDataFirebaseC,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
                'Loading Please Wait...'); // or some loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Consumer<ProviderClass>(
              builder: (BuildContext context, snapshot, Widget? child) =>
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // reverse: true,
                      itemCount: mapListCompleted.length - 1,
                      itemBuilder: (context, index) {
                        print('Index : $index');
                        String taskName =
                            mapListCompleted.keys.elementAt(index + 1);
                        Map<String, dynamic> task =
                            mapListCompleted[taskName] ?? {};
                        if (task[CONSTANTS.priority] == CONSTANTS.mid) {
                          priorityColor = TColors.white;
                        } else if (task[CONSTANTS.priority] == CONSTANTS.low) {
                          priorityColor = TColors.green;
                        } else if (task[CONSTANTS.priority] == CONSTANTS.high) {
                          priorityColor = TColors.red;
                        } else {
                          priorityColor = TColors.white;
                        }
                        //Tap using a GestureDetector
                        return cardDesign(task,context);
                      },
                    ),
                  ));
        });
  }
}
