import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Add%20Task/addtask.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/AppBar/appbar.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int selectedIndex = 1;
Color themeButtonColor = Colors.green;
var changedText;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // context.read<ProviderClass>().startTimer();
    // context.read<ProviderClass>().getData();
    // context.read<ProviderClass>().currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    void _handleSubmitted(String text) {
      textController.clear();

      setState(() {});
    }

    return Scaffold(
      appBar: AppBarClass(context),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: TStrings.group),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: TStrings.task),
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
    );
  }
}

Widget _body() {
  return Column(
    children: [
      Flexible(
        fit: FlexFit.tight,
        flex: 1,
        child: Builder(
          builder: (BuildContext context) => widgetOptions[selectedIndex],
        ),
      ),
      _buildTextComposer()
    ],
  );
}

Widget _buildTextComposer() {
  return Container(
      // color: Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
        Expanded(
            child: Container(
                // color: Colors.transparent,
                decoration: BoxDecoration(
                  // backgroundBlendMode: BlendMode.dst,
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Row(children: <Widget>[
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (changedValue) {
                        changedText = changedValue;
                        print(changedValue);
                      },
                      decoration: const InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        // filled: true,
                        // fillColor: Colors.transparent
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        print('Filter');
                      },
                      icon: Icon(MdiIcons.filter))
                ]))),
        const AddTask()
      ]));
}

final List<Widget> widgetOptions = <Widget>[
  const Text(
    'Group',
  ),
  const TaskScreen(),
  const Text(
    'Complete',
  ),
];
