// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/groupprovider.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  const ChatScreen({super.key, required this.chat});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  late var id; // Use late to delay initialization
  late var name; // Use late to delay initialization

  @override
  void initState() {
    super.initState();
    id = widget.chat.groupId;
    name = widget.chat.groupName;
    // context.read<GroupProviderClass>().groupMessageReceiver(id);
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textController,
                autofocus: true,
                // onSubmitted: context.read<GroupProviderClass>().handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type your message...',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                setState(() {
                  context
                      .read<GroupProviderClass>()
                      .handleSubmitted(_textController.text, id);

                  _textController.clear();
                  // context.read<GroupProviderClass>().groupMessageReceiver(id);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: firebaseFirestoreInstance
                    .collection('Groups')
                    .doc(id)
                    .snapshots(),
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  List messages = data?.data()?['messages'];
                  messages = messages.reversed.toList();
                  // context.read<GroupProviderClass>().groupMessageReceiver(id);
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // Future.delayed(const Duration(seconds: 1));
                      return _buildMessage(messages[index]);
                      // return ListTile(leading: Text(messages[index]['msg']));
                    },
                  );
                }),
          ),
          const Divider(height: 1.5),
          _buildTextComposer(),
        ],
      ),
    );
  }

  _buildMessage(var currentMsg) /*async*/ {
    // context.read<GroupProviderClass>().groupMessageReceiver(id);
    if (currentMsg['senderUID'] == currentUserUid) {
      return ListTile(
        title: Container(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8.0)),
                  // margin: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          'You',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        // width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 8.0, left: 8.0),
                              child: Text(
                                currentMsg['msg'],
                                softWrap: true,
                                // textAlign: TextAlign.right,
                                style: const TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: Image.network(currentUserPhoto).image,
                ),
              ],
            )),
      );
    } else {
      print("currentMsg : ${currentMsg['msg']}");
      return ListTile(
        title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  backgroundImage:
                      Image.network(currentMsg['senderProfile']).image,
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          currentMsg['name'] ?? 'User',
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        // width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 8.0, left: 8.0),
                              child: Text(
                                currentMsg['msg'],
                                softWrap: true,
                                // textAlign: TextAlign.right,
                                style: const TextStyle(
                                  overflow: TextOverflow.visible,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    }
  }
}

class Chat {
  final String groupId;
  final String groupName;

  Chat(this.groupId, this.groupName);
}
