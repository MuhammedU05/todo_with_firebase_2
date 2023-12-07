// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class FireBaseClass {
  String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }
}
