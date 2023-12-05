import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Icon addTaskPlusIcon = Icon(
  Icons.add_circle_outline,
  color: Colors.black,
  size: 55,
);
Icon profileIcon = Icon(Icons.account_box);
Icon completed =
    Icon(Icons.done_outline_sharp, color: Colors.lightGreen, fill: 1);
// Icon profileIcon = Icon(Icons.account_box);
// Icon profileIcon = Icon(Icons.account_box);
// Icon profileIcon = Icon(Icons.account_box);
// Icon profileIcon = Icon(Icons.account_box);
// Icon profileIcon = Icon(Icons.account_box);
// Icon profileIcon = Icon(Icons.account_box);

enum Priority { high, mid, low }

const List<(Priority, String)> priorityOptions = <(Priority, String)>[
  (Priority.high, 'High'),
  (Priority.mid, 'Mid'),
  (Priority.low, 'Low'),
];

