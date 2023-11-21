import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/Utils/firebase_file.dart';
import 'package:todo_with_firebase_2/screens/Home/card.dart';

FireBaseClass fireBaseClass = FireBaseClass();
CardBuilder cardBuilder = CardBuilder();
// var providerClass = context.read<ProviderClass>();
// var currentUserEmail = FirebaseAuth.instance.currentUser?.email;
var currentUser = FirebaseAuth.instance.currentUser;
