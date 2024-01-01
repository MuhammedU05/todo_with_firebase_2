import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/groupprovider.dart';
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
    // context.read<GroupProviderClass>().documentLengthGetter();
    context.read<GroupProviderClass>().countGetter();
    // Future.delayed(Durations.short2,
    //     () => context.read<GroupProviderClass>().countGetter());
    print('Profile Page Running');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            Container(
              height: height / 3.0,
              width: double.infinity,
              color: lightBlue,
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 3.0),
              child: Container(
                // height: MediaQuery.of(context).size.height / 2.95,
                height: height / 1.5,
                width: double.infinity,
                color: darkBlue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: IconButton(
                  color: yellowShade,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
            ),
            SizedBox(
              // height: 400,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                    child: Stack(children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: yellowShade,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: Image.network(
                            currentUserPhoto ?? CONSTANTS.userNotFound,
                            filterQuality: FilterQuality.high,
                          ).image,
                        ),
                      ),
                    ]),
                  ),
                  Center(
                    child: SizedBox(
                      height: height / 5.5,
                      width: double.infinity,
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                currentUserName ?? 'User',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 251, 242, 177),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                currentUserEmail ?? 'Email Not Found',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 251, 242, 177),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // const Spacer(),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 5,
                                      ), //Border.all
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: yellowShade2,
                                          blurRadius: 3.0,
                                          spreadRadius: 0.5,
                                        ), //BoxShadow
                                        BoxShadow(
                                          color: yellowShade,
                                        ), //BoxShadow
                                      ],
                                    ),
                                    //BoxDecoration Widget
                                    child: StreamBuilder(
                                        stream: firebaseFirestoreInstance
                                            .collection('Groups')
                                            .where("members",
                                                arrayContains: currentUserUid)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          var data = snapshot.data;

                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data!.docs.length.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                ),
                                                const Text(
                                                  "Groups",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                )
                                              ]);
                                        }),
                                  ),
                                ), //Container
                                // const Spacer(),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 5,
                                      ), //Border.all
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: yellowShade2,
                                          blurRadius: 3.0,
                                          spreadRadius: 0.5,
                                        ), //BoxShadow
                                        BoxShadow(
                                            color: yellowShade), //BoxShadow
                                      ],
                                    ),
                                    //BoxDecoration Widget
                                    child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '1',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                            Text(
                                              "Contacts",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            )
                                          ]),
                                  ),
                                ), //Center
                                // const Spacer(),
                                Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 5,
                                    ), //Border.all
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: yellowShade2,
                                        offset: Offset.zero, //Offset
                                        blurRadius: 3.0,
                                        spreadRadius: 0.5,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: yellowShade,
                                        offset: Offset.zero,
                                      ), //BoxShadow
                                    ],
                                  ),
                                  //BoxDecoration Widget
                                  child:  StreamBuilder(
                                    stream: firebaseFirestoreInstance
              .collection('Users')
              .doc(firebaseAuthInstance.currentUser!.uid)
              .snapshots(),
                                    builder: (context, snapshot) {
                                      var data = snapshot.data?.data();

                                       // Assuming you have two lists named 'list1' and 'list2'
            var list1 = data?['Completed Tasks'] as List? ?? [];
            var list2 = data?['Tasks'] as List? ?? [];

            list1.removeWhere(
                (element) => element['Task Name'] == 'First Created');
            list2.removeWhere(
                (element) => element['Task Name'] == 'First Created');

            // Combine list1 and list2
            var combinedList = List.from(list1)..addAll(list2);
                                      return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              combinedList.length.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                            const Text(
                                              "Tasks",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            )
                                          ]);
                                    }
                                  ),
                                ), //Container
                                // const Spacer(),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            // const Spacer(),
            Padding(
              padding: EdgeInsets.only(top: height / 1.08, left: width / 2.53),
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(yellowShade)),
                  onPressed: () async {
                    setState(() {
                      context
                          .read<LoginProviderClass>()
                          .clearDataSignOut(context);
                    });
                  },
                  child: Text('SignOut',
                      style: TextStyle(color: darkBlue, fontSize: 17))),
            ),
          ]),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton:
    );
  }
}
