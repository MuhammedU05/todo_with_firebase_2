// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/firebase_options.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';
import 'package:todo_with_firebase_2/screens/Login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderClass()),
        ChangeNotifierProvider(create: (_) => LoginProviderClass())
      ],
      child: const MaterialApp(
        home: LoginChecker(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class LoginChecker extends StatefulWidget {
  const LoginChecker({Key? key});

  @override
  State<LoginChecker> createState() => _LoginCheckerState();
}

class _LoginCheckerState extends State<LoginChecker> {
@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null &&
        user.email != null &&
        user.email!.isNotEmpty &&
        user.emailVerified) {
      return const HomePage();
    } else {
      return const Login();
    }
  }
}
