// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';

class GroupProviderClass extends ChangeNotifier {
  // var groupId = const Uuid().v4();
  String uid = const Uuid().v1();
  void getNewUid() {
    uid = const Uuid().v4();
    // groupId = const Uuid().v4();
    print('Creation of New Uid');
    // notifyListeners();
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> createGroupFunction(
    String groupName,
    BuildContext context,
    List<String> members,
  ) async {
    print('Creating a new chat group');
    getNewUid();
    await groupCollection.doc(uid).set({
      "groupID": uid,
      "created on": DateTime.now().toString(),
      "groupName": groupName,
      "members": members,
      "admin": currentUserEmail,
      "last Message": 'Last Message',
      "updated on": formatDate(DateTime.now(), /*[dd, ' - ', mm, ' - ', yy]*/ [
        dd,
        ' - ',
        mm,
        ' - ',
        yy,
        ' (',
        HH,
        ':',
        nn,
        ')'
      ]),
    });
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // Future<void> sendGroupMessage(
  //     String group, String sender, String uid, String message) async {
  //   try {
  //     List? msg;
  //     msg!.add({
  //       'sender': sender,
  //       'senderUID': uid,
  //       'senderProfile': currentUserPhoto,
  //       'message': message,
  //       'timestamp': ServerValue.timestamp,
  //       'time': formatDate(DateTime.now(), [yy, mm, dd, HH, nn, ss, SSS, uuu]),
  //     });
  //     await firebaseFirestoreInstance
  //         .collection('Groups')
  //         .doc(group)
  //         .set({'Messages': msg},SetOptions(merge: true));

  //     // databaseReference.child(group).child('Messages').push().set(msg);
  //   } on Exception catch (e) {
  //     print("Exception Caught $e");
  //   }
  //   Future.delayed(Duration.zero, () => notifyListeners());
  // }

  // Future<void> groupMessageReceiver(String id) async {
  //   DatabaseReference ref =
  //       FirebaseDatabase.instance.ref("Groups/$id/Messages");
  //   DatabaseEvent event = await ref.once();

  //   // var ref = firebaseFirestoreInstance.collection('Groups').doc(id);
  //   // var event = await ref.get();
  //   // Explicitly cast snapshot.value to Map<dynamic, dynamic>?
  //   Map<dynamic, dynamic>? messagesDatas =
  //       event.snapshot.value as Map<dynamic, dynamic>?;

  //   currentMessages.clear();
  //   // List? j;
  //   if (messagesDatas != null) {
  //     // Iterate over each unique ID (message ID) in the "Messages" node

  //     // for (var i = 0; i < messagesData.length - 1; i++) {
  //     //   j!.add(messagesData[i]['Messages']);
  //     // }
  //     // print(j);
  //     messagesDatas.forEach((messageId, messageData) {
  //     //   // Perform null checks before accessing values
  //       String uid = messageData['senderUID'] ?? '';
  //       String time = messageData['time'] ?? '';
  //       String message = messageData['message'] ?? '';
  //       String photo = messageData['senderProfile'] ?? '';
  //       String name = messageData['sender'] ?? '';
  //       int timestamp = messageData['timestamp'] ?? 0;

  //       int parsedTime;
  //       // parsedTime =
  //       // DateTime.fromMillisecondsSinceEpoch(time as int).millisecond;
  //       try {
  //         parsedTime = int.parse(time);
  //       } catch (e) {
  //         // Handle the case where the date format is invalid
  //         print("Invalid date format: $time");
  //         return;
  //       }

  //       currentMessages.add({
  //         'message': message,
  //         'sender': name,
  //         'senderProfile': photo,
  //         'senderUID': uid,
  //         'time': time,
  //         'timestamp': timestamp,
  //       });
  //     });

  //     // Sort the list by 'time'
  //     currentMessages
  //         .sort((a, b) => int.parse(b['time']).compareTo(int.parse(a['time'])));

  //     // Display the sorted messages
  //     // j!.forEach((message) {
  //     currentMessages.forEach((message) {
  //       // print("Sender: ${message['sender']}");
  //       // print("Time: ${message['time']}");
  //       print("Message: ${message['message']}");
  //       // print("Message: ${message['message']}");
  //       // print("Message: ${message['message']}");
  //       print("");
  //       // print("Timestamp: ${message['timestamp']}");
  //     });
  //   }

  //   Future.delayed(Duration.zero, () => notifyListeners());
  // }

  Future<void> sendGroupMessage(String group, String message) async {
    final userRef = FirebaseFirestore.instance.collection('Groups').doc(group);
    await userRef.update({
      "messages": FieldValue.arrayUnion([
        {
          "name": currentUserName,
          'senderUID': currentUserUid,
          'senderProfile': currentUserPhoto,
          "msg": message,
          "time":
              formatDate(DateTime.now(), [yy, mm, dd, HH, nn, ss, SSS, uuu]),
        },
      ]),"updated on": formatDate(
              DateTime.now(), /*[dd, ' - ', mm, ' - ', yy]*/ [
            dd,
            ' - ',
            mm,
            ' - ',
            yy,
            ' (',
            HH,
            ':',
            nn,
            ')'
          ]),
    });
  }

  // Future<void> groupMessageReceiver(String id) async {
  //   var docSnapshot =
  //       await FirebaseFirestore.instance.collection('Groups').doc(id).get();
  //   if (docSnapshot.exists) {
  //     List<Map<String, dynamic>> messages = [];
  //     messages = docSnapshot.data()!["messages"];
  //     messages.retainWhere((element) => element["senderUID"] != currentUserUid);
  //     // setGroupChatMessages(messages);
  //   } else {
  //     print("No such document.");
  //   }

  //   // final userRef = FirebaseFirestore.instance.collection('Groups').doc(id);
  //   // await userRef.update({
  //   //   "messages": FieldValue.arrayUnion([
  //   //     {
  //   //       "name": currentUserName,
  //   //       'senderUID': currentUserUid,
  //   //       'senderProfile': currentUserPhoto,
  //   //       "time": formatDate(DateTime.now(), [yy, mm, dd, HH, nn, ss, SSS, uuu]),
  //   //     }
  //   //   ])
  //   // });
  //   notifyListeners();
  // }

  void handleSubmitted(String message, String id) {
    if (message.isNotEmpty) {
      gMessages.insert(0, message);
      sendGroupMessage(id, message);

      // groupMessageReceiver(id);
      // context.read<GroupProviderClass>().groupMessageReceiver(id);
    }
    notifyListeners();
  }
}
// New Uid  :16e2d9c7-a445-40d2-b1c1-35c385a36f98
// First Uid:16e2d9c7-a445-40d2-b1c1-35c385a36f98
