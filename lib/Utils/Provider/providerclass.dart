// provider_class.dart

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_with_firebase_2/Firebase/things.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
// import 'package:timeago/timeago.dart' as timeago;

class ProviderClass extends ChangeNotifier {
  // var currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final document = FirebaseFirestore.instance.collection("Users").snapshots();

  bool isLoading = false;
  Map<String, dynamic> mapList = {};

  Future<void> addFirebaseData(String taskName, String time, String date,
      String selectedGroup, String priority, bool isCompleted) async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // If the document doesn't exist, create it
        await userDocRef.set({'Tasks': []});
      }

      var tasksArray = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;

      tasksArray.add({
        'Task Name': taskName,
        'Created Time': time,
        'Created Date': date,
        'Assign To': selectedGroup,
        'AA': firebaseInstance.currentUser!.displayName,
        'Priority': priority,
        'TimeStamp':
            "${DateTime.timestamp().year}${DateTime.timestamp().month}${DateTime.timestamp().day}${DateTime.timestamp().hour}${DateTime.timestamp().second}${DateTime.timestamp().millisecond}${DateTime.timestamp().microsecond}",
        'Is Completed': isCompleted
      });

      await userDocRef.update({'Tasks': tasksArray});

      notifyListeners();
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  // var currentUser = FirebaseAuth.instance.currentUser;
  // final userCollection = FirebaseFirestore.instance.collection('Users');
  final String defaultPic =
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

  String pic = FirebaseAuth.instance.currentUser?.photoURL?.toString() ??
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";
  String currentUserFDetails =
      FirebaseAuth.instance.currentUser?.displayName ?? "";

  var userDocData;
  var tasks;

  updateCurrentUser() {
    pic = FirebaseAuth.instance.currentUser?.photoURL?.toString() ?? defaultPic;
    currentUserFDetails = FirebaseAuth.instance.currentUser?.displayName ?? "";
    // currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  bool signedIn = false;
  // Map<String, dynamic> mapList = {};
  updateUserMap() {
    print('pppppppppppppppppppppppppppppppppppppppp');
    mapList.clear();
    notifyListeners();
    print(mapList);
    print('ssssssssssssssssss');
  }

  Future<void> getFirebaseDatas() async {
    try {
      isLoading = true;
      mapList.clear();
      var userDoc =
          await userCollection.doc(firebaseInstance.currentUser!.uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('Tasks')) {
        var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
        tasks.forEach((task) {
          // Assuming 'TimeStamp' field contains the user's name
          var taskName = task['TimeStamp'] ?? 'N/A';
          mapList[taskName] = task;
          notifyListeners();
        });

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error getting data: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  late var dataFirebase = getFirebaseDatas();
  updateData() {
    print('\n\nkkkkkkkkkkkkkkkk');
    dataFirebase = getFirebaseDatas();

    // print(jsonDecode(dataFirebase.toString())  );
    print('MapList --->  $mapList');
    notifyListeners();
  }

  Future<String> getCurrentUserProfile() async {
    var pic = FirebaseAuth.instance.currentUser?.photoURL?.toString() ?? "";
    notifyListeners();
    return pic;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print(" google User : $googleUser");
    print(" Credential : $credential");
    print(
        'Photo URL : ${FirebaseAuth.instance.currentUser?.photoURL?.toString()}');
    print('Display Name : ${FirebaseAuth.instance.currentUser?.displayName}');
    print('Current User : ${FirebaseAuth.instance.currentUser}');

    // addFirebaseDataFirst();
    notifyListeners();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void dispose() {
    super.dispose();
    // Remove any additional cleanup code if necessary
  }

  // Future<void> updateMessage(bool value) async {
  //   var userDocRef =
  //       FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid);
  //   var userDoc = await userDocRef.get();

  //   // if (!userDoc.exists) {
  //     // If the document doesn't exist, create it
  //     // await userDocRef.set({'Tasks': []});
  //   // }
  //   if (userDoc.exists && userDoc.data()?['Tasks'][{'TimeStamp'}]){       //data()!.containsKey('Tasks')) {
  //     var tasks = (userDoc.data()?['Tasks'][{'Status'}] ?? []) as List<dynamic>;
  //     tasks.forEach((task) {
  //       // Assuming 'AA' field contains the user's name
  //       // var taskName = task['TimeStamp'] ?? 'N/A';
  //       // mapList[taskName] = task;

  //     });
  //   }
  // }

  Future<void> updateMessage(String taskTimeStamp, bool isCompleted) async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data()?['Tasks'] != null) {
        var tasks = userDoc.data()?['Tasks'] as List<dynamic>;

        // Find the task with the specified TimeStamp
        var updatedTasks = tasks.map((task) {
          if (task['TimeStamp'] == taskTimeStamp) {
            task['Is Completed'] = isCompleted;
          }
          return task;
        }).toList();

        // Update the Tasks field in the document
        await userDocRef.update({'Tasks': updatedTasks});
        notifyListeners();
      }
    } catch (e) {
      print("Error updating message: $e");
    }
  }

  String getPriorityString(Priority priority) {
    for (var option in priorityOptions) {
      if (option.$1 == priority) {
        return option.$2;
      }
    }
    notifyListeners();
    return ''; // Default value if not found
  }

  Future<void> addFirebaseDataFirst() async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser?.uid);
      var userDoc = await userDocRef.get();
      print('User Doc : $userDoc');
      if (userDoc.data()!.isNotEmpty) {
        print('User Doc is Empty');
        if (!userDoc.exists) {
          // If the document doesn't exist, create it
          // await userDocRef.set({'Tasks': []});
        } else {
          await userDocRef.set({'Tasks': []}, SetOptions(merge: true));
        }

        var tasksArray = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;

        tasksArray.add({
          'Task Name': 'First Created',
          'Created Time': DateTime.now().toString(),
          'Created Date': '',
          'Assign To': '',
          'AA': firebaseInstance.currentUser?.displayName,
          'Priority': '',
          'TimeStamp': '',
          // "${DateTime.timestamp().year}${DateTime.timestamp().month}${DateTime.timestamp().day}${DateTime.timestamp().hour}${DateTime.timestamp().second}${DateTime.timestamp().millisecond}${DateTime.timestamp().microsecond}",
          'Is Completed': false
        });

        await userDocRef.update({'Tasks': tasksArray});
        print('Created Dummy Task');
        notifyListeners();
      } else {
        print('User Doc is Not Empty');
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print("Error adding data First: $e");
    }
  }

  Future<void> checkFirebaseDataExist() async {
    var userDoc =
        await userCollection.doc(firebaseInstance.currentUser!.uid).get();
    print('Checking Firebase Data Exist Or Not');

    if (userDoc.exists && userDoc.data()!.containsKey('Tasks')) {
      // var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
      // tasks.forEach((task) {
      //   // Assuming 'TimeStamp' field contains the user's name
      //   var taskName = task['TimeStamp'] ?? 'N/A';
      //   mapList[taskName] = task;
      // notifyListeners();
      // });
      print('Firebase Data Exists');

      // isLoading = false;
      notifyListeners();
    } else {
      // isLoading = false;
      addFirebaseDataFirst();
      notifyListeners();
    }
  }
}
