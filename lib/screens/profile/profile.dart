import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
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

    context.read<LoginProviderClass>().currentUserSaver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.3,
              width: double.infinity,
              color: Colors.grey.shade500,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
            ),
            SizedBox(
              height: 350,
              child: Column(
                children: [
                  
                  Padding(
                        padding: const EdgeInsets.only(top:40.0,bottom: 10),
                        child: Stack(children: [
                          const CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: Image.network(
                                currentUserPhoto??CONSTANTS.userNotFound,
                                filterQuality: FilterQuality.high,
                              ).image,
                            ),
                          ),
                        ]),
                      ),
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 5.5,
                      width: double.infinity,
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text(
                                currentUserName ?? 'User',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currentUserEmail ?? 'Email Not Found',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
        onPressed: () async {
          setState(() {
            context.read<LoginProviderClass>().clearDataSignOut(context);
          });
        },
        child: const Text('SignOut'),
      ),
    );
  }
}
