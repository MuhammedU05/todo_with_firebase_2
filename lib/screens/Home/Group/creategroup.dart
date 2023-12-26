// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
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
  var dataF = firebaseFirestoreInstance.collection('All Users').snapshots();
  // late List<bool> _selected;
  // var _selected;
  late List<bool> _selected;

  List<String> selectedUsers = [];
  // List<bool> _selected = List.filled(_selected.length, false, growable: true);

  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().getAllUser();
    _showUserList = false;
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
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
                    });
                  },
                ),

                const SizedBox(
                  height: 10,
                ),
                !_showUserList
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 1.6,
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height / 1.6,
                        child: StreamBuilder(
                            stream: dataF,
                            builder: (context, snapshot) {
                              var docDataF = snapshot.data;
                              _selected = List.filled(
                                  docDataF?.docs.length ?? 0, false,
                                  growable: true);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: docDataF?.docs.length,
                                  itemBuilder: ((context, index) {
                                    var detailsData = docDataF?.docs[index];

                                    // selectedUsers.add(detailsData?['UID']);
                                    if (_selected.isEmpty&&docDataF!.docs.isNotEmpty) {
                                      for (var i = 0;
                                          i < docDataF.docs.length;
                                          i++) {
                                        _selected.add(false);
                                        print(
                                            'adding false to _selected : $_selected');
                                      }
                                    }
                                    // _selected.add(false);
                                    // print('Added $selected');

                                    return Card(
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Text(detailsData?['NAME'] ??
                                                "Name Not Found"),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  // _selected[_selected.indexOf(detailsData?['UID'])] = !_selected[_selected.indexOf(detailsData?['UID'])];

                                                  // _selected[_selected.indexOf(detailsData?['UID'])]?
                                                  // selectedUsers
                                                  //     .add(detailsData?['UID'])
                                                  // : selectedUsers.remove(
                                                  //     detailsData?['UID']);
                                                  _selected[index] =
                                                      !_selected[index];

                                                  print('Added $_selected\n t');
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
                                                  backgroundColor:
                                                      MaterialStateColor
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
                                                    detailsData?['Photo'] ??
                                                        'https://i0.wp.com/digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png?fit=500%2C500&ssl=1')
                                                .image),
                                      ),
                                    );
                                  }));
                            }),
                        // ),
                      ),
                //Create Group & Cancel Button
                Row(mainAxisSize: MainAxisSize.min, children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (_) => Colors.green)),
                      child: const Text('Create Group',
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 14),
                  OutlinedButton(
                      onPressed: () {
                        _groupNameController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'))
                ])
              ],
            ),
          ),
        ));
  }
}
