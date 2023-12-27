// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class FirebaseProviderClass extends ChangeNotifier {
  late var dataFirebase = getFirebaseDatas();
  late var dataFirebaseC = getFirebaseDatasCompleted();

  Future<void> addFirebaseData(
      String taskName,
      String time,
      String date,
      String selectedGroup,
      String priority,
      bool isCompleted,
      String completedDate,
      String completedTime,
      DateTime dueTo,
      String editedDueDate) async {
    try {
      // var userDocRef = FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(firebaseAuthInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // If the Tasks doesn't exist, create it
        await userDocRef.set({TStrings.tasksFirebase: []});
        await userDocRef.set(
            {TStrings.completedTasksFirebase: []}, SetOptions(merge: true));
      }

      var tasksArray =
          (userDoc.data()?[TStrings.tasksFirebase] ?? []) as List<dynamic>;

      tasksArray.add({
        TStrings.taskNameFirebase: taskName,
        TStrings.createdTimeFirebase: time,
        TStrings.createdDateFirebase: date,
        TStrings.assignedToFirebase: selectedGroup,
        'AA': firebaseAuthInstance.currentUser!.displayName,
        TStrings.priorityFirebase: priority,
        TStrings.timeStampFirebase:
            "${DateTime.timestamp().year}${DateTime.timestamp().month}${DateTime.timestamp().day}${DateTime.timestamp().hour}${DateTime.timestamp().second}${DateTime.timestamp().millisecond}${DateTime.timestamp().microsecond}",
        TStrings.isCompletedFirebase: isCompleted,
        TStrings.dueToFirebase: dueTo,
        TStrings.completedDateFirebase: 'Not Completed',
        TStrings.completedTimeFirebase: 'Not Completed',
        'Edited DueDate': editedDueDate
      });
      // TStrings.taskNameFirebase
      // TStrings.createdTimeFirebase
      // TStrings.createdDateFirebase
      // TStrings.assignedToFirebase
      // TStrings.priorityFirebase
      // TStrings.isCompletedFirebase
      // TStrings.completedDateFirebase
      // TStrings.completedTimeFirebase
      // TStrings.dueToFirebase

      await userDocRef.update({TStrings.tasksFirebase: tasksArray});

      Future.delayed(Duration.zero, () => notifyListeners());
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
          await userCollection.doc(firebaseAuthInstance.currentUser!.uid).get();

      if (userDoc.exists &&
          userDoc.data()!.containsKey(TStrings.tasksFirebase)) {
        var tasks =
            (userDoc.data()?[TStrings.tasksFirebase] ?? []) as List<dynamic>;
        for (var task in tasks) {
          // Assuming TStrings.timeStampFirebase field contains the user's name
          var timeStamp = task[TStrings.timeStampFirebase] ?? 'N/A';
          mapList[timeStamp] = task;
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

        Future.delayed(Duration.zero, () => notifyListeners());
      } else {
        isLoading = false;

        Future.delayed(Duration.zero, () => notifyListeners());
      }
    } catch (e) {
      print("Error getting data: $e");
      isLoading = false;

      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  Future<void> getFirebaseDatasCompleted() async {
    try {
      isLoadingCompleted = true;
      // print('MapList Length : ${mapList.length}');

      mapListCompleted.clear();
      var userDoc =
          await userCollection.doc(firebaseAuthInstance.currentUser!.uid).get();

      if (userDoc.exists &&
          userDoc.data()!.containsKey(TStrings.completedTasksFirebase)) {
        var tasks = (userDoc.data()?[TStrings.completedTasksFirebase] ?? [])
            as List<dynamic>;
        for (var task in tasks) {
          // Assuming TStrings.timeStampFirebase field contains the user's name
          var taskName = task[TStrings.timeStampFirebase] ?? 'N/A';
          mapListCompleted[taskName] = task;
          // notifyListeners();
        }

        isLoadingCompleted = false;

        Future.delayed(Duration.zero, () => notifyListeners());
      } else {
        isLoadingCompleted = false;

        Future.delayed(Duration.zero, () => notifyListeners());
      }
    } catch (e) {
      print("Error getting data: $e");
      isLoadingCompleted = false;

      Future.delayed(Duration.zero, () => notifyListeners());
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
      String priority,
      DateTime dueTo,
      String editedDueDate) async {
    try {
      var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseAuthInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists &&
          userDoc.data()?[TStrings.tasksFirebase] != null &&
          userDoc.data()?[TStrings.completedTasksFirebase] != null) {
        var tasks = userDoc.data()?[TStrings.tasksFirebase] as List<dynamic>;
        var completedMap =
            userDoc.data()?[TStrings.completedTasksFirebase] as List<dynamic>;

        // Use Future.wait to wait for all asynchronous tasks to complete
        var updatedTasks = await Future.wait(tasks.map((task) async {
          if (task[TStrings.timeStampFirebase] == taskTimeStamp) {
            task[TStrings.isCompletedFirebase] = isCompleted;
            task[TStrings.assignedToFirebase] = selectedGroup;
            task[TStrings.taskNameFirebase] = taskName;
            task[TStrings.priorityFirebase] = priority;
            task[TStrings.completedDateFirebase] = completedDate;
            task[TStrings.completedTimeFirebase] = completedTime;
            task[TStrings.dueToFirebase] = dueTo;
            task['Edited DueDate'] = editedDueDate;
            if (isCompleted == true) {
              completedMap.add({
                TStrings.taskNameFirebase: taskName,
                TStrings.createdTimeFirebase:
                    task[TStrings.createdTimeFirebase],
                TStrings.createdDateFirebase:
                    task[TStrings.createdDateFirebase],
                TStrings.assignedToFirebase: selectedGroup,
                TStrings.aaFirebase:
                    firebaseAuthInstance.currentUser?.displayName,
                TStrings.priorityFirebase: priority,
                TStrings.timeStampFirebase: task[TStrings.timeStampFirebase],
                TStrings.isCompletedFirebase: true,
                TStrings.completedDateFirebase: completedDate,
                TStrings.completedTimeFirebase: completedTime,
                TStrings.dueToFirebase: dueTo,
                'Edited DueDate': editedDueDate
              });
              await userDocRef
                  .update({TStrings.completedTasksFirebase: completedMap});
              deleteTask(taskTimeStamp);
              // updateData();

              // Update the Tasks field in the document

              // Future.delayed(Duration.zero, () => notifyListeners());
            }
          }
          return task;
        }).toList());

        // Update the Tasks field in the document after all async tasks complete
        await userDocRef.update({TStrings.tasksFirebase: updatedTasks});

        Future.delayed(Duration.zero, () => notifyListeners());
      }
    } catch (e) {
      print("Error updating message: $e");
    }
  }

// To Delete the Task
  Future<void> deleteTask(String taskTimeStamp) async {
    try {
      // var userDocRef = FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(firebaseAuthInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data()?[TStrings.tasksFirebase] != null) {
        var tasks = userDoc.data()?[TStrings.tasksFirebase] as List<dynamic>;

        // Find the index of the task with the specified TimeStamp
        int indexOfTaskToDelete = tasks.indexWhere(
            (task) => task[TStrings.timeStampFirebase] == taskTimeStamp);

        if (indexOfTaskToDelete != -1) {
          // Task found, remove it from the list
          tasks.removeAt(indexOfTaskToDelete);

          // Update the Tasks field in the document
          await userDocRef.update({TStrings.tasksFirebase: tasks});
          print('Task Deleted');
          // notifyListeners();
        } else {
          print('Task with TimeStamp $taskTimeStamp not found');
        }
      }

      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e) {
      print("Error Deleting Task: $e");

      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  // Future<void> checkFirebaseDataExist() async {
  //   var userDoc =
  //       await userCollection.doc(firebaseAuthInstance.currentUser!.uid).get();
  //   print('Checking Firebase Data Exist Or Not');

  //   if (userDoc.exists && userDoc.data()!.containsKey(TStrings.tasksFirebase)) {
  //     // var tasks = (userDoc.data()?[TStrings.tasksFirebase] ?? []) as List<dynamic>;
  //     // tasks.forEach((task) {
  //     //   // Assuming TStrings.timeStampFirebase field contains the user's name
  //     //   var taskName = task[TStrings.timeStampFirebase] ?? 'N/A';
  //     //   mapList[taskName] = task;
  //     // notifyListeners();
  //     // });
  //     print('Firebase Data Exists');

  //     // isLoading = false;
  //
  // Future.delayed(Duration.zero, () => notifyListeners());
  //   } else {
  //     // isLoading = false;
  //     addFirebaseDataFirst();
  //
  // Future.delayed(Duration.zero, () => notifyListeners());
  //   }
  // }

  updateData() async {
    try {
      print('k\nk\nkkkkkkkkkkkkkkkk');
      dataFirebase = getFirebaseDatas();
      dataFirebaseC = getFirebaseDatasCompleted();

      // print(jsonDecode(dataFirebase.toString()));
      print('MapList --->  $mapList');
      print('MapList Completed --->  $mapListCompleted');
      Future.delayed(Duration.zero, () => notifyListeners());
    } on Exception catch (e) {
      print('Date Updation Error : $e');
    }
  }

  updateUserMap(BuildContext context) async {
    try {
      print('pppppppppppppppppppppppppppppppppppppppp');
      mapList.clear();
      mapListCompleted.clear();
      print(mapList);
      context.read<LoginProviderClass>().updateCurrentUser();
      print('ssssssssssssssssss');
      Future.delayed(Duration.zero, () => notifyListeners());
    } on Exception catch (e) {
      print('Updating UserMap Error : $e');
    }
  }

  void completeTask() {
    if (selected == true) {
      isCompletedSelected = true;
    } else {
      isCompletedSelected = false;
    }

    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> addFirebaseDataFirst() async {
    try {
      // var userDocRef = FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(firebaseAuthInstance.currentUser?.uid);
      var userDoc = await userDocRef.get();
      print('User Doc : ${userDoc.exists}');
      print('User Doc : ${!userDoc.exists}');
      if (!userDoc.exists) {
        print('User Doc is Empty');

        // If the document doesn't exist, create it
        // await userDocRef.set({TStrings.tasksFirebase: []});
        await userDocRef
            .set({TStrings.tasksFirebase: []}, SetOptions(merge: true));
        await userDocRef.set({'Completed Tasks': []}, SetOptions(merge: true));
        var tasksArray =
            (userDoc.data()?[TStrings.tasksFirebase] ?? []) as List<dynamic>;

        tasksArray.add({
          TStrings.taskNameFirebase: 'First Created',
          TStrings.createdTimeFirebase: DateTime.now().toString(),
          // TStrings.createdDateFirebase: '',
          // TStrings.assignedToFirebase: '',
          'AA': firebaseAuthInstance.currentUser?.displayName,
          // TStrings.priorityFirebase: '',
          // TStrings.timeStampFirebase: '',
          // TStrings.dueToFirebase: '',
          // // "${DateTime.timestamp().year}${DateTime.timestamp().month}${DateTime.timestamp().day}${DateTime.timestamp().hour}${DateTime.timestamp().second}${DateTime.timestamp().millisecond}${DateTime.timestamp().microsecond}",
          // TStrings.isCompletedFirebase: false,
          // TStrings.completedDateFirebase: '',
          // TStrings.completedTimeFirebase: '',
        });

        await userDocRef.update({TStrings.tasksFirebase: tasksArray});
        await userDocRef.update({TStrings.completedTasksFirebase: tasksArray});
        print('Created Dummy Task');

        Future.delayed(Duration.zero, () => notifyListeners());
      } else {
        print('User Doc is Not Empty');

        Future.delayed(Duration.zero, () => notifyListeners());
      }

      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e) {
      print("Error adding data First: $e");
    }
  }

  // To Update the Massages
  Future<void> checkCompleted(String taskTimeStamp) async {
    try {
      // var userDocRef = FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(firebaseAuthInstance.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists && userDoc.data()?[TStrings.tasksFirebase] != null) {
        var tasks = userDoc.data()?[TStrings.tasksFirebase] as List<dynamic>;

        // Find the task with the specified TimeStamp
        var updatedTasks = tasks.map((task) async {
          if (task[TStrings.isCompletedFirebase] == true) {
            addFirebaseData(
                task[TStrings.taskNameFirebase],
                task[TStrings.createdTimeFirebase],
                task[TStrings.createdDateFirebase],
                task[TStrings.assignedToFirebase],
                task[TStrings.priorityFirebase],
                task[TStrings.isCompletedFirebase],
                task[TStrings.completedDateFirebase],
                task[TStrings.completedTimeFirebase],
                task[TStrings.dueToFirebase],
                task['Edited DueDate']);
          }
          return task;
        }).toList();
        // var completedChanger = tasks['Is Completed'] == true ?

        // Update the Tasks field in the document
        await userDocRef.update({TStrings.tasksFirebase: updatedTasks});

        Future.delayed(Duration.zero, () => notifyListeners());
      }
    } catch (e) {
      print("Error updating message: $e");
    }
  }

  // Future<void> getAllUser() async {
  //   try {
  //     var querySnapshot = await savingUser.get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       allUsersDatas.clear();
  //       for (var doc in querySnapshot.docs) {
  //         var memberData = doc.data();
  //         // Assuming each document has a field 'uid' representing the member's UID
  //         memberData['UID'] = doc.id;
  //         allUsersDatas.add(memberData);
  //       }
  //       print('getAllUsers Completed');
  //       Future.delayed(Duration.zero, () => notifyListeners());
  //     } else {
  //       print('No data found in the collection');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     // Handling the error if any
  //   }
  // }

  Future<void> getFirebaseUserDatas() async {
    try {
      mapListUsers.clear();
      var userDoc = await savingUser.doc('All Users').get();
      int i = 0;
      if (userDoc.exists && userDoc.data()!.containsKey('Users')) {
        var tasks = (userDoc.data()?['Users'] ?? []) as List<dynamic>;

        for (var task in tasks) {
          // Assuming task['UID'] contains the user's UID
          print('UID of task : ${task['UID']} ');
          if (task['UID'] != currentUserUid) {
            print('Not Current User');
            var uid = i.toString();
            mapListUsers[uid] = task;
            print('object');
            print('#$mapListUsers');
            // Perform additional actions for each user here
            // For example, you can access specific fields like task['NAME']
            // and perform operations on them.
          i++;
          }
        }
        tasks.clear();
        // print('#######################\n${mapListUsers[0]['NAME']}');
        // print('#######################\n${mapListUsers['UID']}');
        // print('##########(--)############\n${mapListUsers[0]}');
        Future.delayed(Duration.zero, () => notifyListeners());
      } else {
        Future.delayed(Duration.zero, () => notifyListeners());
      }
    } catch (e) {
      print("Error getting data: $e");
      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }
}
