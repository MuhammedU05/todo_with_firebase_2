import 'package:flutter/widgets.dart';
import 'package:todo_with_firebase_2/Utils/Assign/assign.dart';

class ProviderClass extends ChangeNotifier {
  bool signedIn = false;

  int selectedIndex = 0;

  void isSignIn() {
    print("isSigned is Running Now");
    if (currentUser != null) {
      signedIn = true;
      print("Provider Class SignIn : $signedIn");
      notifyListeners();
    }
  }

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
