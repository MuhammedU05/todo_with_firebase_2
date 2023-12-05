
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseInstance = FirebaseAuth.instance;
var userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseInstance.currentUser!.uid);
      // var userDoc = await userDocRef.get();