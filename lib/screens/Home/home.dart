import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/Home/card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      // body: _body(),
      body: _widgetOptions,
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: Colors.blueGrey,
    centerTitle: true,
    title: Text('Task'),
    actions: [
      IconButton(
          iconSize: 40,
          onPressed: () {},
          icon: const Icon(
            Icons.person,
            color: Colors.orange,
          ))
    ],
  );
}

Widget _body() {
  return Center(
        // child: widgetOptions.elementAt(),
        child: ,
    
  );
}

BottomNavigationBar _bottomNavigationBar(){
  return BottomNavigationBar(items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Group'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.task),
        label: 'Task'
        ),
        BottomNavigationBarItem(icon: Icon(Icons.done_outline),
        label: 'Completed')
  ],
  currentIndex: context.read<ProviderClass>().selectedIndex,
  elevation: 20,);
}


List<Widget> _widgetOptions = <Widget>[
    Text(
      'Group',
    ),
    Text(
      'Task',
    ),
    Text(
      'Complete',
    ),
  ];

