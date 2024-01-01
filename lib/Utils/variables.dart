// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:todo_with_firebase_2/Utils/Const/icons.dart';

var userDocData;
var tasks;
var selectedPriority;
var allUserUid;
var userDocRef = firebaseFirestoreInstance
    .collection('Users')
    .doc(firebaseAuthInstance.currentUser?.uid);
var allUserRef =
    firebaseFirestoreInstance.collection('All Users').doc('All Users');
var savingUser = firebaseFirestoreInstance.collection('All Users');
var groupCollection = firebaseFirestoreInstance.collection('Groups');
final DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref().child('Groups');

List<bool> toggleButtonsSelection =
    Priority.values.map((Priority e) => e == Priority.mid).toList();
List<dynamic> currentMessages = [];
List<String> groups = ['Me'];
var allUsersDatas;
  final List<String> gMessages = [];

final firebaseAuthInstance = FirebaseAuth.instance;
final firebaseFirestoreInstance = FirebaseFirestore.instance;
// final user = FirebaseAuth.instance.currentUser;
final TextEditingController taskNameController = TextEditingController();
final userCollection = FirebaseFirestore.instance.collection('Users');
final document = FirebaseFirestore.instance.collection("Users").snapshots();
final TextEditingController textController = TextEditingController();
final TextEditingController textControllerSearch = TextEditingController();
final TextEditingController inputValue = TextEditingController();
final ItemScrollController scrollControllerSearch = ItemScrollController();

bool isLoading = true;
bool isLoadingSearch = true;
bool isLoadingCompleted = true;
bool selected = false;
bool signedIn = false;
bool isCompletedSelected = false;

Map<String, dynamic> mapList = {};
Map<String, dynamic> mapListUsers = {};
// Map<String, dynamic> allUsersDatas = {};
Map<String, dynamic> mapListSearch = {};
Map<String, dynamic> mapListCompleted = {};

final startTime =
    DateTime(currentTime.year, currentTime.month, currentTime.day, 10, 24);
final endTime =
    DateTime(currentTime.year, currentTime.month, currentTime.day, 13, 50);

final currentTime = DateTime.now();

// currentTime.isAfter(startTime) && currentTime.isBefore(endTime),

Color selectedColor = Colors.yellow;

const String defaultPic =
    "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

// var currentUserFDetails = FirebaseAuth.instance.currentUser;

String pic = currentUserAll?.photoURL?.toString() ??
    "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";

String time = formatDate(DateTime.now(), [HH, ' : ', nn]);
String date = formatDate(DateTime.now(), [dd, ' - ', mm, ' - ', yy]);
late String? selectedGroup;

var currentUserAll = FirebaseAuth.instance.currentUser;
var currentUserName;
var currentUserEmail;
var currentUserPhoto;
var currentUserUid;
