// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class GroupProviderClass extends ChangeNotifier {
  var groupId = const Uuid().v4();
  groupCreation() {
    // groupCollection.doc()
    print('First Uid:$uid');
    print("Group Uid:$groupId");
    getNewUid();
    print('New Uid:$uid');
    print("Group New Uid: $groupId");
    getNewUid();
    print("Group Created");
    Future.delayed(Duration.zero, () => notifyListeners());
    // notifyListeners();
  }

  String uid = const Uuid().v4();
  void getNewUid() {
    uid = const Uuid().v4();
    groupId = const Uuid().v4();
    print('Creation of New Uid');
    // notifyListeners();
    Future.delayed(Duration.zero, () => notifyListeners());
  }
}
// New Uid  :16e2d9c7-a445-40d2-b1c1-35c385a36f98
// First Uid:16e2d9c7-a445-40d2-b1c1-35c385a36f98
