// provider_class.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProviderClass extends ChangeNotifier {
  var currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final document = FirebaseFirestore.instance.collection("Users").snapshots();

  bool isLoading = false;
  Map<String, dynamic> mapList = {};

  Future<void> addFirebaseData(String taskName, String time, String date,
      String selectedGroup, String priority) async {
    try {
      var userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid);
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
        'AA': currentUser!.displayName,
        'Priority': priority,
        'TimeStamp':
            "${DateTime.timestamp().day}${DateTime.timestamp().hour}${DateTime.timestamp().second}${DateTime.timestamp().millisecond}${DateTime.timestamp().microsecond}"
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
    currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  bool signedIn = false;
  // Map<String, dynamic> mapList = {};
  updateuserMap() {
    print('pppppppppppppppppppppppppppppppppppppppp');
    mapList.clear();
    notifyListeners();
    print(mapList);
    print('ssssssssssssssssss');
  }

//   bool isLoading = false;
//  Future<void> addFirebaseData(String taskName, String time, String date,
//     String selectedGroup, String priority) async {
//   try {
//     // Create a map for the new task
//     Map<String, dynamic> newTask = {
//       'Task Name': taskName,
//       'Created Time': time,
//       'Created Date': date,
//       'Assign To': selectedGroup,
//       'AA': currentUser!.displayName.toString(),
//       'Priority': priority,
//     };

//     // Get the current user's document reference
//     var userDocRef = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid);

//     // Get the current 'Tasks' array
//     var tasksArray = (await userDocRef.get()).data()?['Tasks'] ?? [];

//     // Add the new task to the 'Tasks' array
//     tasksArray.add(newTask);

//     // Update the 'Tasks' array in the document
//     await userDocRef.update({'Tasks': tasksArray});

//     notifyListeners();
//   } catch (e) {
//     print("Error adding data: $e");
//   }
// }

// }
// bool isLoading = false;
// Map<String, dynamic> mapList = {};

// Future<void>updateFirebaseData() async {
// var userDoc = await userCollection.doc(currentUser!.uid).get();

// }

  Future<void> getFirebaseDatas() async {
    try {
      isLoading = true;
      mapList.clear();
      var userDoc = await userCollection.doc(currentUser!.uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('Tasks')) {
        var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
        tasks.forEach((task) {
          // Assuming 'AA' field contains the user's name
          var taskName = task['TimeStamp'] ?? 'N/A';
          mapList[taskName] = task;
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
    print(FirebaseAuth.instance.currentUser?.photoURL?.toString());
    print(FirebaseAuth.instance.currentUser?.displayName);
    notifyListeners();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void dispose() {
    super.dispose();
    // Remove any additional cleanup code if necessary
  }

  Future<void> updateMessage(bool value) async {
    var userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid);
    var userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      // If the document doesn't exist, create it
      // await userDocRef.set({'Tasks': []});
    }
    if (userDoc.exists && userDoc.data()!.containsKey('Tasks')) {
      var tasks = (userDoc.data()?['Tasks'][{'Status'}] ?? []) as List<dynamic>;
      tasks.forEach((task) {
        // Assuming 'AA' field contains the user's name
        // var taskName = task['TimeStamp'] ?? 'N/A';
        // mapList[taskName] = task;

      });
    }
  }
}
