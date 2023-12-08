// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';

class FirebaseProviderClass extends ChangeNotifier {
  late var dataFirebase = getFirebaseDatas();
  // late var dataCompletedFirebase = getCompletedFirebaseDatas();

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

      var userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // If the Tasks doesn't exist, create it
        await userDocRef.set({'Tasks': []});
        await userDocRef.set({'Completed Tasks': []}, SetOptions(merge: true));
      }

      var tasksArray = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;

      tasksArray.add({
        TStrings.taskNameFirebase: taskName,
        'Created Time': time,
        'Created Date': date,
        TStrings.assignedToFirebase: selectedGroup,
        'AA': firebaseAuthInstance.currentUser!.displayName,
        TStrings.priorityFirebase: priority,
        TStrings.timeStampFirebase:
            "${DateTime.timestamp().year}${DateTime.timestamp().month}${DateTime.timestamp().day}${DateTime.timestamp().hour}${DateTime.timestamp().second}${DateTime.timestamp().millisecond}${DateTime.timestamp().microsecond}${DateTime.timestamp()}",
        TStrings.isCompletedFirebase: isCompleted,
        TStrings.completedDateFirebase: 'Not Completed',
        TStrings.completedTimeFirebase: 'Not Completed'
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
      mapListCompleted.clear();
      var userDoc =
          await userCollection.doc(firebaseAuthInstance.currentUser!.uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('Tasks')) {
        var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
        for (var task in tasks) {
          // Assuming TStrings.timeStampFirebase field contains the user's name
          var taskName = task[TStrings.timeStampFirebase] ?? 'N/A';
          mapList[taskName] = task;
          // notifyListeners();
        }
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
      isLoadingCompleted = true;

      if (userDoc.exists && userDoc.data()!.containsKey('Completed Tasks')) {
        var tasks = (userDoc.data()?['Completed Tasks'] ?? []) as List<dynamic>;
        for (var task in tasks) {
          // Assuming TStrings.timeStampFirebase field contains the user's name
          var taskName = task[TStrings.timeStampFirebase] ?? 'N/A';
          mapListCompleted[taskName] = task;
          // notifyListeners();
        }
        isLoadingCompleted = false;
        notifyListeners();
      } else {
        isLoadingCompleted = false;
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
      var userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data()?['Tasks'] != null) {
        var tasks = userDoc.data()?['Tasks'] as List<dynamic>;
        var completedMap = userDoc.data()?['Completed Tasks'] as List<dynamic>;

        // Find the task with the specified TimeStamp
        var updatedTasks = tasks.map((task) async {
          if (task[TStrings.timeStampFirebase] == taskTimeStamp) {
            print(
                '$isCompleted\n$selectedGroup\n$taskName\n$priority\n$completedDate\n$completedTime\n$taskTimeStamp');

            task[TStrings.isCompletedFirebase] = isCompleted;
            task[TStrings.assignedToFirebase] = selectedGroup;
            task[TStrings.taskNameFirebase] = taskName;
            task[TStrings.priorityFirebase] = priority;
            task[TStrings.completedDateFirebase] = completedDate;
            task[TStrings.completedTimeFirebase] = completedTime;
            print(
                '$isCompleted\n$selectedGroup\n$taskName\n$priority\n$completedDate\n$completedTime\n$taskTimeStamp');
            if (isCompleted == true) {
              completedMap.add({
                TStrings.taskNameFirebase: taskName,
                'Created Time': task[TStrings.createdTimeFirebase],
                'Created Date': task[TStrings.createdDateFirebase],
                TStrings.assignedToFirebase: selectedGroup,
                'AA': firebaseAuthInstance.currentUser?.displayName,
                TStrings.priorityFirebase: priority,
                TStrings.timeStampFirebase: task[TStrings.timeStampFirebase],
                TStrings.isCompletedFirebase: true,
                TStrings.completedDateFirebase: completedDate,
                TStrings.completedTimeFirebase: completedTime,
              });
              await userDocRef.update({'Completed Tasks': completedMap});
              deleteTask(taskTimeStamp);
              updateData();
            }
            notifyListeners();
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

// To Delete the Task
  Future<void> deleteTask(String taskTimeStamp) async {
    try {
      var userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data()?['Tasks'] != null) {
        var tasks = userDoc.data()?['Tasks'] as List<dynamic>;

        // Find the index of the task with the specified TimeStamp
        int indexOfTaskToDelete = tasks.indexWhere(
            (task) => task[TStrings.timeStampFirebase] == taskTimeStamp);

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
    try {
      var userDoc =
          await userCollection.doc(firebaseAuthInstance.currentUser!.uid).get();
      print('Checking Firebase Data Exist Or Not');

      if (userDoc.exists && userDoc.data()!.containsKey('Tasks')) {
        // var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
        // tasks.forEach((task) {
        //   // Assuming TStrings.timeStampFirebase field contains the user's name
        //   var taskName = task[TStrings.timeStampFirebase] ?? 'N/A';
        //   mapList[taskName] = task;
        // notifyListeners();
        // });
        print('Firebase Data Tasks Exists');

        // isLoading = false;
        notifyListeners();
      } else {
        // isLoading = false;
        addFirebaseDataFirst();
        notifyListeners();
      }
      if (userDoc.exists && userDoc.data()!.containsKey('Completed Tasks')) {
        // var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
        // tasks.forEach((task) {
        //   // Assuming TStrings.timeStampFirebase field contains the user's name
        //   var taskName = task[TStrings.timeStampFirebase] ?? 'N/A';
        //   mapList[taskName] = task;
        // notifyListeners();
        // });
        print('Firebase Data Completed Tasks Exists');

        // isLoading = false;
        notifyListeners();
      } else {
        // isLoading = false;
        addFirebaseDataFirst();
        notifyListeners();
      }
    } on Exception catch (e) {
      print('Error Chacking If Firebase Data Exists : $e');
    }
  }

  updateData() {
    try {
      print('\n\nkkkkkkkkkkkkkkkk');
      dataFirebase = getFirebaseDatas();
      // dataCompletedFirebase = getCompletedFirebaseDatas();
      // isLoadingCompleted = false;
      // print(jsonDecode(dataFirebase.toString()));
      print('MapList --->  $mapList');
      notifyListeners();
    } on Exception catch (e) {
      print('Data updating Error : $e');
    }
  }

  updateUserMap() {
    try {
      print('pppppppppppppppppppppppppppppppppppppppp');
      mapList.clear();
      mapListCompleted.clear();
      notifyListeners();
      print(mapList);
      print('ssssssssssssssssss');
    } on Exception catch (e) {
      print('Updating User Map Error : $e');
    }
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
          TStrings.taskNameFirebase: 'First Created',
          'Created Time': DateTime.now().toString(),
          'Created Date': '',
          TStrings.assignedToFirebase: '',
          'AA': firebaseAuthInstance.currentUser?.displayName,
          TStrings.priorityFirebase: '',
          TStrings.timeStampFirebase: '',
          // "${DateTime.timestamp().year}${DateTime.timestamp().month}${DateTime.timestamp().day}${DateTime.timestamp().hour}${DateTime.timestamp().second}${DateTime.timestamp().millisecond}${DateTime.timestamp().microsecond}",
          TStrings.isCompletedFirebase: '',
          TStrings.completedDateFirebase: '',
          TStrings.completedTimeFirebase: ''
        });

        await userDocRef.update({'Tasks': tasksArray});
        await userDocRef.update({'Completed Tasks': tasksArray});
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
}
