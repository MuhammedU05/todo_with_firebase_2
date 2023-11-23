import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

@override
void initState() {
  // super.initState();
  fireBaseClass.getfirebaseUser();
  // print(fireBaseClass.);
}

int selectedIndex = 1;
Color themeButtonColor = Colors.green;
final TextEditingController textController = TextEditingController();
final TextEditingController inputValue = TextEditingController();
var changedText;

class _HomePageState extends State<HomePage> {
  void _handleSubmitted(String text) {
    textController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.group), label: Strings.group),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: Strings.task),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_outline), label: Strings.completed)
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
    );
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: Colors.blueGrey,
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('Welcome, ${currentUser!.displayName}'),
    actions: [
      GestureDetector(
        // child: Image.network(currentUser!.photoURL!),
        onTap: () {},
        child: CircleAvatar(
            backgroundImage: Image.network(currentUser!.photoURL!).image),
        // child: Image.network(currentUser!.photoURL!),
      ),
    ],
  );
}

Widget _body() {
  return Flexible(
    child: Column(
      children: [
        Builder(
          builder: (BuildContext context) => Expanded(
            child: widgetOptions[selectedIndex],
          ),
        ),
        _buildTextComposer(),
      ],
    ),
  );
}

Widget _buildTextComposer() {
  return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
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
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        print('Filter');
                      },
                      icon: Icon(MdiIcons.filter))
                ])))
      ]));
}

  final List<Widget> widgetOptions = <Widget>[
    Text(
      'Group',
    ),
    TaskScreen(),
    Text(
      'Complete',
    ),
  ];