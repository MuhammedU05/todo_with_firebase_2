import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/screens/Home/Group/chatscreen.dart';
import 'package:todo_with_firebase_2/screens/Home/Group/creategroup.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                    stream: firebaseFirestoreInstance
                        .collection('Groups')
                        .where("members", arrayContains: currentUserUid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                            'Loading Please Wait..'); // or some loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Data Found"),
                        );
                      } else if (data!.docs.isEmpty) {
                        return const Center(
                          child: Text("Please Make A Group"),
                        );
                      }
                      return ListView.builder(
                        itemCount: data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = data.docs[index];
                          var members = doc.get('members');
                          // var dataMembers = members.get(field);
                          if (members != currentUserUid) {}
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  doc['groupName'] ?? '',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(doc['last Message senderUID'] == currentUserUid ? "You : ${doc['last Message']}" :"${doc['last senderName']} : ${doc['last Message']}"),
                                trailing: Text(doc['updated on'] ?? ''),
                                onTap: () {
                                  print('Tapped on Group name');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              chat: Chat(
                                                  doc.id,
                                                  doc['groupName'] ??
                                                      'Group'))));
                                },
                              ),
                              const Divider(
                                thickness: 2.5,
                              )
                            ],
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
          // Positioned(
          //   top: -20,
          //   right: 7,
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 7, top: 7),
          //     child: AnimSearchBar(
          //       autoFocus: true,
          //       color: Colors.indigoAccent,
          //       searchIconColor: Colors.white,
          //       textFieldColor: Colors.blueAccent,
          //       textFieldIconColor: Colors.white,
          //       width: 400,
          //       textController: textController,
          //       onSuffixTap: () {
          //         setState(() {});
          //       },
          //       onSubmitted: (v) {},
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateGroup()),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
      ),
    );
  }
}