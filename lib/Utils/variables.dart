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

final firebaseAuthInstance = FirebaseAuth.instance;
final firebaseFirestoreInstance = FirebaseFirestore.instance;
var userDocRef = firebaseFirestoreInstance
    .collection('Users')
    .doc(firebaseAuthInstance.currentUser?.uid);
var userDetailsGroup =
    FirebaseFirestore.instance.collection('All Users').doc('List');
List<String> groups = ['Me'];
late String? selectedGroup;
var selectedPriority;
String time = formatDate(DateTime.now(), [HH, ' : ', nn]);
String date = formatDate(DateTime.now(), [dd, ' - ', mm, ' - ', yy]);

List<bool> toggleButtonsSelection =
    Priority.values.map((Priority e) => e == Priority.mid).toList();

final user = firebaseAuthInstance.currentUser;
final TextEditingController taskNameController = TextEditingController();
final selectedColor = Colors.yellow.shade400;
final userCollection = FirebaseFirestore.instance.collection('Users');
final document = FirebaseFirestore.instance.collection("Users").snapshots();
final TextEditingController textController = TextEditingController();
final TextEditingController inputValue = TextEditingController();

bool isLoading = true;
bool isLoadingSearch = true;
bool isLoadingCompleted = true;
bool selected = false;
bool signedIn = false;
late bool isCompletedSelected;
Map<String, dynamic> mapList = {};
Map<String, dynamic> mapListSearch = {};
Map<String, dynamic> mapListCompleted = {};
