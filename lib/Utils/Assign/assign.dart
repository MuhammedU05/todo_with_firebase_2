import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_with_firebase_2/Utils/firebase_file.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Card/card.dart';

FireBaseClass fireBaseClass = FireBaseClass();
CardBuilder cardBuilder =  CardBuilder(data: [],);
// var providerClass = context.read<ProviderClass>();
// var currentUserEmail = FirebaseAuth.instance.currentUser?.email;
var currentUser = FirebaseAuth.instance.currentUser;