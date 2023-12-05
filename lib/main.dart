// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/firebase_options.dart';
import 'package:todo_with_firebase_2/screens/Home/Tasks/Add%20Task/addtask.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';
import 'package:todo_with_firebase_2/screens/Login/login.dart';

// Connecting Firebase in Main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // If we're in debug mode, use the normal error widget which shows the error
    // message:
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }
    // In release builds, show a white-on-blue message instead:
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error!\n${details.exception}',
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      ),
    );
  };
  runApp(MyApp());
}

//Using Providers
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderClass()),
        ChangeNotifierProvider(create: (_) => LoginProviderClass()),
        ChangeNotifierProvider(create: (_) => FirebaseProviderClass())
      ],
      child: MaterialApp(
        builder: (context, widget) {
          Widget error = Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator()
                // child: Text("Error"),
              ));
          if (widget is Scaffold || widget is Navigator) {
            error = Scaffold(body: Center(child: error));
          }
          ErrorWidget.builder = (errorDetails) => error;
          if (widget != null) return widget;
          throw ('widget is null');
        },
        debugShowCheckedModeBanner: false,
        home: const LoginChecker(),
      ),
  );
  }
}

class LoginChecker extends StatefulWidget {
  const LoginChecker({Key? key});

  @override
  State<LoginChecker> createState() => _LoginCheckerState();
}

// Check If its SignedIn Or Not
class _LoginCheckerState extends State<LoginChecker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (user != null &&
        user!.email != null &&
        user!.email!.isNotEmpty &&
        user!.emailVerified) {
      return const HomePage();
    } else {
      return const Login();
    }
  }
}
