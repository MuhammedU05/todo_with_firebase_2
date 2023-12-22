import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 7,top: 7),
            child: AnimSearchBar(
              autoFocus: true,
              color:Colors.indigoAccent,
              searchIconColor: Colors.white,
              textFieldColor: Colors.blueAccent,
              textFieldIconColor: Colors.white,
              width: 400,
              textController: textController,
              // style: const TextStyle(
              //   // color: Colors.,
              // ),
              onSuffixTap: () {
                setState(() {});
              },
              onSubmitted: (v) {},
            ),
          ),
          // SizedBox(width: MediaQuery.of(context).size.width/1.0111111,child: const SearchBar(),)
        ],
      ),
      // body: ,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => const CreateGroup())));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
