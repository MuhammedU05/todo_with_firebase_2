// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';

const String defaultPic =
    "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

String pic = FirebaseAuth.instance.currentUser?.photoURL?.toString() ??
    "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

String currentUserFDetails =
    FirebaseAuth.instance.currentUser?.displayName ?? "";

var userDocData;
var tasks;

final user = FirebaseAuth.instance.currentUser;

final TextEditingController taskNameController = TextEditingController();
List<String> groups = ['Me'];
late String? selectedGroup;
var selectedPriority;
String time = formatDate(DateTime.now(), [HH, ' : ', nn]);
String date = formatDate(DateTime.now(), [dd, ' - ', mm, ' - ', yy]);

List<bool> toggleButtonsSelection =
    Priority.values.map((Priority e) => e == Priority.mid).toList();
final Color selectedColor = Colors.yellow.shade400;

final userCollection = FirebaseFirestore.instance.collection('Users');
final document = FirebaseFirestore.instance.collection("Users").snapshots();

bool isLoading = false;
late bool isCompletedSelected;
  bool selected = false;
bool signedIn = false;
Map<String, dynamic> mapList = {};
