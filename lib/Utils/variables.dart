// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';
import 'package:todo_with_firebase_2/Utils/firebase_file.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/card.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Add%20Task/addtask.dart';

//vars
var tasks;
var userDocData;
var changedText;
var selectedPriority;
var userDocRef = firestoreInstance
    .collection('Users')
    .doc(firebaseAuthInstance.currentUser!.uid);

//ints
int selectedIndex = 1;

//bools
bool isLoading = true;
bool selected = false;
bool signedIn = false;
late bool isCompletedSelected;
bool isLoadingCompleted = true;

//maps
Map<String, dynamic> mapList = {};
Map<String, dynamic> mapListCompleted = {};

//colors
Color themeButtonColor = Colors.green;
final Color selectedColor = Colors.yellow.shade400;

//lists
List<String> groups = ['Me'];
List<bool> toggleButtonsSelection =
    Priority.values.map((Priority e) => e == Priority.mid).toList();

//finals
final firebaseAuthInstance = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;
final TextEditingController inputValue = TextEditingController();
final TextEditingController textController = TextEditingController();
final userCollection = firestoreInstance.collection('Users');
final TextEditingController taskNameController = TextEditingController();

//strings
late String? selectedGroup;
const String googleLogo = 'assets/GoogleLogo.png';
String currentUserFDetails = firebaseAuthInstance.currentUser?.displayName ?? "";
String pic = firebaseAuthInstance.currentUser?.photoURL?.toString() ?? defaultPic;
String time = formatDate(DateTime.now(), [HH, ' : ', nn]);
String date = formatDate(DateTime.now(), [dd, ' - ', mm, ' - ', yy]);
const String defaultPic =
    "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

//instance
AddTask addTaskClass = const AddTask();
FireBaseClass? fireBaseClass = FireBaseClass();
CardBuilder cardBuilder =  const CardBuilder();