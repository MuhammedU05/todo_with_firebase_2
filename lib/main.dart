// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_with_firebase_2/Utils/Provider/groupprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/themeprovider.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';
import 'package:todo_with_firebase_2/firebase_options.dart';
import 'package:todo_with_firebase_2/screens/Home/home.dart';
import 'package:todo_with_firebase_2/screens/Login/login.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Connecting Firebase in Main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

// String appName = packageInfo.appName;
// String packageName = packageInfo.packageName;
  try {
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    String? serverVersion = FirebaseRemoteConfig.instance.getString('Version');
    if (serverVersion == version) {
      _isUpdated = true;
    } else {
      _isUpdated = false;
    }
  } on Exception catch (e) {
    print('Error Getting APP Version : $e');
  }

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
        style: const TextStyle(color: Color.fromARGB(255, 210, 145, 145)),
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
          ChangeNotifierProvider(create: (_) => FirebaseProviderClass()),
          ChangeNotifierProvider(create: (_) => ThemeProviderClass()),
          ChangeNotifierProvider(create: (_) => GroupProviderClass()),
        ],
        child: Consumer<ThemeProviderClass>(
            builder: (context, themeProvider, child) {
          return MaterialApp(
            // theme: themeProvider.currentTheme,
            // darkTheme: themeProvider.currentTheme,
            // theme: ThemeData.light(),
            // darkTheme: ThemeData.dark(),
            // themeMode: currentTime.isAfter(startTime) && currentTime.isBefore(endTime) ? ThemeMode.light : ThemeMode.dark,
            builder: (context, widget) {
              Widget error = Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.white,
                  child: const Center(
                    // child: CircularProgressIndicator()
                    child: Text(""),
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
          );
        }));
  }
}

late bool _isUpdated;

class VersionChecker extends StatelessWidget {
  const VersionChecker({super.key});

  @override
  Widget build(BuildContext context) {
// PackageInfo packageInfo = await PackageInfo.fromPlatform();

// String appName = packageInfo.appName;
// String packageName = packageInfo.packageName;
// String version = packageInfo.version;
// String buildNumber = packageInfo.buildNumber;
    //fetching version from remote config
    if (_isUpdated) {
      return const LoginChecker();
    }
    return AlertDialog.adaptive(
        backgroundColor: Theme.of(context).primaryColorDark,
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        titleTextStyle: const TextStyle(color: Colors.white),
        content: Text("Update To Latest Version"));
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
    if (currentUserAll != null &&
        currentUserAll!.email != null &&
        currentUserAll!.email!.isNotEmpty &&
        currentUserAll!.emailVerified) {
      return const HomePage();
    } else {
      return const Login();
    }
  }
}
