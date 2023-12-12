import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/loginproviderclass.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(firebaseAuthInstance.currentUser!.displayName.toString()),
      ),
      body: const Column(
        children: [
          Center(
            child: Text('Hi'),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
          onPressed: () async {
            setState(() {
              context.read<LoginProviderClass>().clearDataSignOut(context);
            });
          },
          child: const Text('SignOut'),),
    );
  }
}
