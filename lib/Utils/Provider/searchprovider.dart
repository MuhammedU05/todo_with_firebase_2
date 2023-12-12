// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class SearchProviderClass extends ChangeNotifier {

  late var dataFirebase = getFirebaseDatasSearching();

  Future<void> getFirebaseDatasSearching() async {
    try {
      isLoadingSearch = true;

      mapListSearch.clear();
      var userDoc =
          await userCollection.doc(firebaseAuthInstance.currentUser!.uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('Tasks') ||
          userDoc.data()!.containsKey('Completed Tasks')) {
        var tasks = (userDoc.data()?['Tasks'] ?? []) as List<dynamic>;
        var tasksC =
            (userDoc.data()?['Completed Tasks'] ?? []) as List<dynamic>;
        for (var task in tasks) {
          // Assuming 'TimeStamp' field contains the user's name
          var taskName = task['TimeStamp'] ?? 'N/A';
          mapListSearch[taskName] = task;
        }
        for (var task in tasksC) {
          // Assuming 'TimeStamp' field contains the user's name
          var taskName = task['TimeStamp'] ?? 'N/A';
          mapListSearch[taskName] = task;
        }

        isLoadingSearch = false;
        notifyListeners();
      } else {
        isLoadingSearch = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error getting data: $e");
      isLoadingSearch = false;
      notifyListeners();
    }
  }
}
