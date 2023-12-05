import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';

class Navigators extends Builder {
  Navigators({required super.builder});
  // Navigator homePage = Navigator(onGenerateRoute: ,)

  @override
  Navigator build(BuildContext context) {
    Navigator homePage = Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage())) as Navigator;

    return homePage;
  }
}
