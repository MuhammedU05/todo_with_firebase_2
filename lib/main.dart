import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
      providers: [ChangeNotifierProvider(create: (_) => ProviderClass())],
      child: MaterialApp(
        home: LoginChecker(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class LoginChecker extends StatelessWidget {
  const LoginChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null && user.email!.isNotEmpty) {
      return const HomePage();
    } else {
      return const Login();
    }
  }
}
