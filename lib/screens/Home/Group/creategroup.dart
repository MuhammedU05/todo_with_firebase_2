// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/groupprovider.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  bool _showUserList = false;
  final TextEditingController _groupNameController = TextEditingController();
  final _myFocusNode = FocusNode();
  // var dataF = firebaseFirestoreInstance.collection('All Users').snapshots();
  var dataF = [];

  // late List<bool> _selected;
  // var _selected;
  List<bool> _selected = [false];

  List<String> selectedUsers = [currentUserUid];
  // List<bool> _selected = List.filled(_selected.length, false, growable: true);

  @override
  void initState() {
    super.initState();

    // context.read<FirebaseProviderClass>().getAllUser();
    context.read<FirebaseProviderClass>().getFirebaseUserDatas();
    _showUserList = false;
    _selected.clear();
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    selectedUsers.clear();
    _groupNameController.clear();
    _selected.clear();
    //...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Group'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                TextField(
                  autofocus: true,
                  controller: _groupNameController,
                  focusNode: _myFocusNode,
                  decoration: const InputDecoration(labelText: 'Group Name'),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.lightGreen,
                    ),
                    child: Row(children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.people_alt_rounded),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('Add Users'),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(_showUserList
                            ? Icons.arrow_upward_outlined
                            : Icons.arrow_downward_rounded),
                      ),
                    ]),
                  ),
                  onTap: () {
                    setState(() {
                      _myFocusNode.unfocus();
                      _showUserList = !_showUserList;
                      // context.read<FirebaseProviderClass>().getAllUser();
                      _selected = List.filled(mapListUsers.length, false,
                          growable: true);
                    });
                  },
                ),

                const SizedBox(
                  height: 10,
                ),
                !_showUserList
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 1.8,
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height / 1.8,
                        child:
                            // StreamBuilder(
                            //     stream: dataF,
                            //     builder: (context, snapshot) {
                            //       var docDataF = snapshot.data!.docs;
                            // _selected = List.filled(
                            //     docDataF?.docs.length ?? 0, false,
                            //     growable: true);
                            // return
                            FutureBuilder(
                                future: context
                                    .read<FirebaseProviderClass>()
                                    .getFirebaseUserDatas(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  print('Maplist Users : $mapListUsers');
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                        'Loading Please Wait..'); // or some loading indicator
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (mapListUsers.isEmpty) {
                                    return const Text('No User Found');
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      // itemCount: 1,
                                      itemCount: mapListUsers.length,
                                      itemBuilder: ((context, index) {
                                        // sIndex = index.toString();
                                        print('String Index : $index'); 
                                        // print(
                                        //     'Users Index : ${mapListUsers.length}');
                                        // String taskName =
                                        //    mapListUsers.keys.elementAt(index);
                                        // Map<String, dynamic> task =
                                        //     mapListUsers[taskName] ?? {};
                                        // // var detailsData = docDataF[index];
                                        // print('Added First ${task['NAME']}');
                                        // var user1 = mapListUsers['0'];

                                        // print('#######################\n${mapListUsers[0]['NAME']}');
                                        // print(
                                        //     '#######################\n${user1}');
                                        // print(
                                        //     '##########(--)############\n${mapListUsers}');

                                        return Card(
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                // Text(mapListUsers[index]['NAME']),
                                                Text(mapListUsers[
                                                    index.toString()]['NAME']),
                                                const Spacer(),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _myFocusNode.unfocus();
                                                      // _selected[_selected.indexOf(detailsData?['UID'])] = !_selected[_selected.indexOf(detailsData?['UID'])];

                                                      // _selected[_selected.indexOf(detailsData?['UID'])]?

                                                      _selected[index] =
                                                          !_selected[index];
                                                      _selected[index]
                                                          ? selectedUsers.add(
                                                              mapListUsers[index
                                                                      .toString()]
                                                                  ['UID'])
                                                          : selectedUsers.remove(
                                                              mapListUsers[index
                                                                      .toString()]
                                                                  ['UID']);

                                                      print(
                                                          'Added $_selected\n t');
                                                      print(
                                                          'Added(++++++++++++++++):$selectedUsers\n t');
                                                    });
                                                  },
                                                  icon: Icon(
                                                    !_selected[index]
                                                        ? Icons.add
                                                        : Icons.done,
                                                    color: !_selected[index]
                                                        ? Colors.white
                                                        : Colors.green,
                                                  ),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateColor
                                                          .resolveWith((states) =>
                                                              !_selected[index]
                                                                  ? Colors.green
                                                                      .shade600
                                                                  : Colors
                                                                      .white)),
                                                )
                                              ],
                                            ),
                                            leading: CircleAvatar(
                                                radius: 25,
                                                backgroundImage: Image.network(
                                                        mapListUsers[index
                                                                    .toString()]
                                                                ['Photo'] ??
                                                            CONSTANTS
                                                                .userNotFound)
                                                    .image),
                                          ),
                                        );
                                      }));
                                })
                        // }),
                        // ),
                        ),
                //Create Group & Cancel Button
                Row(mainAxisSize: MainAxisSize.min, children: [
                  OutlinedButton(
                    onPressed: () {
                      // mapListUsers.clear();
                      // _groupNameController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton(
                      onPressed: () {
                        if (_groupNameController.text
                                .replaceAll(' ', '')
                                .isNotEmpty &&
                            selectedUsers.length > 1) {
                          print('Created group Successfully');
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Durations.long4,
                                  content: Text('Created group Successfully'),
                                  backgroundColor: Colors.green));
                          Navigator.pop(context);
                        } else if (_groupNameController.text
                                .replaceAll(' ', '')
                                .isEmpty &&
                            selectedUsers.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Durations.long4,
                                  content: Text('Please Enter Group Name'),
                                  backgroundColor: Colors.red));
                        } else if (_groupNameController.text
                                .replaceAll(' ', '')
                                .isNotEmpty &&
                            selectedUsers.length <= 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Durations.long4,
                                  content: Text(
                                      'Please Select At Least 2 Group Members'),
                                  backgroundColor: Colors.red));
                        }
                        // _groupNameController.text = _groupNameController.text.toUpperCase();
                        print("GRoup Name : ${_groupNameController.text}");
                        context.read<GroupProviderClass>().createGroupFunction(
                            _groupNameController.text, context, selectedUsers);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (_) => Colors.green)),
                      child: const Text('Create Group',
                          style: TextStyle(color: Colors.white))),
                ])
              ],
            ),
          ),
        ));
  }
}
