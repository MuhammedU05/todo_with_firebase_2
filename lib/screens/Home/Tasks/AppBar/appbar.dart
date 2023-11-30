// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/providerclass.dart';
import 'package:todo_with_firebase_2/screens/profile/profile.dart';

AppBar AppBarClass(BuildContext context) {
  return AppBar(
      backgroundColor: Colors.blueGrey,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title:
          Text('Welcome, ${context.read<ProviderClass>().currentUserFDetails}'),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
            // ProfilePage();
          },
          child: CircleAvatar(
            backgroundImage:
                Image.network(context.read<ProviderClass>().pic).image,
          ),
          // child: Text('data')
        )
      ]);
}
