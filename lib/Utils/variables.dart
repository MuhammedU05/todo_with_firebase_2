  // ignore_for_file: prefer_typing_uninitialized_variables

  import 'package:firebase_auth/firebase_auth.dart';

const String defaultPic =
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

  String pic = FirebaseAuth.instance.currentUser?.photoURL?.toString() ??
      "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";
  String currentUserFDetails =
      FirebaseAuth.instance.currentUser?.displayName ?? "";

  var userDocData;
  var tasks;

    final user = FirebaseAuth.instance.currentUser;