// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/screens/Home/Complete/completed.dart';
import 'package:todo_with_firebase_2/screens/Home/Group/groupscreen.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Add%20Task/addtask.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/AppBar/appbar.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Search%20Screen/searchscreen.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int selectedIndex = 1;
Color themeButtonColor = Colors.green;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().addFirebaseDataFirst();
    context.read<LoginProviderClass>().addCollection();
    context.read<LoginProviderClass>().currentUserSaver();
    print("Current User : $currentUserAll");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Durations.medium2,
            content: Text('Cannot Go Back'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBarClass(context),
        body: _body(context),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: TStrings.group),
            BottomNavigationBarItem(
                icon: Icon(Icons.task), label: TStrings.task),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_outline), label: TStrings.completed)
          ],
          selectedItemColor: themeButtonColor,
          // unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            print("on Tap Index : $index");
          },
          elevation: 20,
        ),
        // floatingActionButton: const AddTask(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}

Widget _body(BuildContext context) {
  return Column(
    // fit: StackFit.passthrough,
    children: [
      Flexible(
        fit: FlexFit.tight,
        flex: 1,
        child: Builder(
          builder: (BuildContext context) => widgetOptions[selectedIndex],
        ),
      ),
      _buildTextComposer(context)
    ],
  );
}

Widget _buildTextComposer(BuildContext context) {
  if (selectedIndex != 1) {
    print('Not Selected Tasks');
    return Container();
  }
  // return const Center(child: AddTask());
  return GestureDetector(
    child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(3.0),
        child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  height: 50,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                    // backgroundBlendMode: BlendMode.dst,
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(children: <Widget>[
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: SizedBox(
                        child: Text('Search'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(MdiIcons.filter),
                    )
                  ]))),
          const Center(child: AddTask())
        ])),
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SearchClass()));
    },
  );
}

final List<Widget> widgetOptions = <Widget>[
  const GroupScreen(),
  const TaskScreen(),
  const TaskScreenCompleted()
];
