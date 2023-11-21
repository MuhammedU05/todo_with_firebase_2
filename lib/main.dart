import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/firebase_options.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';
// import 'package:todo_with_firebase_2/screens/Login/login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // } catch (e) {
  // print('Error initializing Firebase: $e');
  // Handle the initialization error, you may choose to show an error screen or exit the app gracefully.
  // }

  // runApp(const MaterialApp(
  //   home: Login(),
  //   debugShowCheckedModeBanner: false,
  // ));

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ProviderClass())],
    child: const MaterialApp(
      // home: Login(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
