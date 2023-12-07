// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_with_firebase_2/Firebase/things.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class FirebaseProviderClass extends ChangeNotifier {
  late var dataFirebase = getFirebaseDatas();

  Future<void> addFirebaseData(
      String taskName,
      String time,
      String date,
      String selectedGroup,
      String priority,
      bool isCompleted,
      String completedDate,
      String completedTime) async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // If the Tasks doesn't exist, create it
        await userDocRef.set({'Tasks': []});
        await userDocRef.set({'zCompleted Tasks': []}, SetOptions(merge: true));
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
        'Is Completed': isCompleted,
        'Completed Date': 'Not Completed',
        'Completed Time': 'Not Completed'
      });

      await userDocRef.update({'Tasks': tasksArray});

      notifyListeners();
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  Future<void> getFirebaseDatas() async {
    try {
      isLoading = true;
      // print('MapList Length : ${mapList.length}');

      mapList.clear();
      var userDoc =
          await userCollection.doc(firebaseInstance.currentUser!.uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('Tasks')) {
        var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
        tasks.forEach((task) {
          // Assuming 'TimeStamp' field contains the user's name
          var taskName = task['TimeStamp'] ?? 'N/A';
          mapList[taskName] = task;
          // notifyListeners();
        });
        // print('MapList Length : ${mapList.length}');
        // if (mapList.length > 1) {
        //   isLoading = false;
        // } else if (mapList.length == 1) {
        //   isLoading = false;
        // } else {
        //   isLoading = true;
        // }
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

  // To Update the Massages
  Future<void> updateMessage(
      String taskTimeStamp,
      bool isCompleted,
      String taskName,
      String selectedGroup,
      String completedTime,
      String completedDate,
      String priority) async {
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
            print(
                '${isCompleted}\n${selectedGroup}\n${taskName}\n${priority}\n${completedDate}\n${completedTime}\n${taskTimeStamp}');

            task['Is Completed'] = isCompleted;
            task['Assign To'] = selectedGroup;
            task['Task Name'] = taskName;
            task['Priority'] = priority;

            task['Completed Date'] = completedDate;
            task['Completed Time'] = completedTime;
            print(
                '${isCompleted}\n${selectedGroup}\n${taskName}\n${priority}\n${completedDate}\n${completedTime}\n${taskTimeStamp}');
            notifyListeners();
          }
          return task;
        }).toList();
        // var completedChanger = tasks['Is Completed'] == true ?

        // Update the Tasks field in the document
        await userDocRef.update({'Tasks': updatedTasks});
        notifyListeners();
      }
    } catch (e) {
      print("Error updating message: $e");
    }
  }

// To Delete the Task
  Future<void> deleteTask(String taskTimeStamp) async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data()?['Tasks'] != null) {
        var tasks = userDoc.data()?['Tasks'] as List<dynamic>;

        // Find the index of the task with the specified TimeStamp
        int indexOfTaskToDelete =
            tasks.indexWhere((task) => task['TimeStamp'] == taskTimeStamp);

        if (indexOfTaskToDelete != -1) {
          // Task found, remove it from the list
          tasks.removeAt(indexOfTaskToDelete);

          // Update the Tasks field in the document
          await userDocRef.update({'Tasks': tasks});
          print('Task Deleted');
          notifyListeners();
        } else {
          print('Task with TimeStamp $taskTimeStamp not found');
        }
      }
    } catch (e) {
      print("Error Deleting Task: $e");
      notifyListeners();
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

  updateData() {
    print('\n\nkkkkkkkkkkkkkkkk');
    dataFirebase = getFirebaseDatas();

    // print(jsonDecode(dataFirebase.toString()));
    print('MapList --->  $mapList');
    notifyListeners();
  }

  updateUserMap() {
    print('pppppppppppppppppppppppppppppppppppppppp');
    mapList.clear();
    notifyListeners();
    print(mapList);
    print('ssssssssssssssssss');
  }

  void completeTask() {
    if (selected == true) {
      isCompletedSelected = true;
    } else {
      isCompletedSelected = false;
    }
    notifyListeners();
  }

  Future<void> addFirebaseDataFirst() async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser?.uid);
      var userDoc = await userDocRef.get();
      print('User Doc : ${userDoc.exists}');
      print('User Doc : ${!userDoc.exists}');
      if (!userDoc.exists) {
        print('User Doc is Empty');

        // If the document doesn't exist, create it
        // await userDocRef.set({'Tasks': []});
        await userDocRef.set({'Tasks': []}, SetOptions(merge: true));
        await userDocRef.set({'Completed Tasks': []}, SetOptions(merge: true));
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
          'Is Completed': false,
          'Completed Date': '',
          'Completed Time': ''
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

  // To Update the Massages
  Future<void> checkCompleted(String taskTimeStamp) async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data()?['Tasks'] != null) {
        var tasks = userDoc.data()?['Tasks'] as List<dynamic>;

        // Find the task with the specified TimeStamp
        var updatedTasks = tasks.map((task) async {
          if (task['Is Completed'] == true) {
            addFirebaseData(
                task[TStrings.taskNameFirebase],
                task[TStrings.createdTimeFirebase],
                task[TStrings.createdDateFirebase],
                task[TStrings.assignedToFirebase],
                task[TStrings.priorityFirebase],
                task[TStrings.isCompletedFirebase],
                task[TStrings.completedDateFirebase],
                task[TStrings.completedTimeFirebase]);
          }
          return task;
        }).toList();
        // var completedChanger = tasks['Is Completed'] == true ?

        // Update the Tasks field in the document
        await userDocRef.update({'Tasks': updatedTasks});
        notifyListeners();
      }
    } catch (e) {
      print("Error updating message: $e");
    }
  }
}
