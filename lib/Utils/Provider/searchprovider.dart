import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/screens/Home/Complete/completed.dart';

class SearchProviderClass extends ChangeNotifier {
  Future<void> findCard(dynamic cardIsCompleted, BuildContext context, dynamic cardTimeStamp) async {
    if (cardIsCompleted == true) {
      // await ; 
      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const TaskScreenCompleted())));
      notifyListeners();
    }
    else if (cardIsCompleted == false){
      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const TaskScreenCompleted())));
    }
  }
}
