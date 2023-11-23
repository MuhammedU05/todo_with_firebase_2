import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class CardBuilder extends StatelessWidget {
  final List <DocumentSnapshot> data; // Replace DocumentSnapshot with your actual data type

   CardBuilder({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return buildCard(data[index]);
      },
    );
  }

  Widget buildCard(document) {
    // Extract data from the document or use your custom data structure
    // String taskName = document['taskName'];
    // DateTime createdAt = document['createdAt'];

    return Card(
      child: Container(
        color: Colors.green,
        width: double.maxFinite,
        height: 250,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  ' Task Name',
                  style: TextStyle(fontSize: 25),
                ),
                Spacer(),
                Column(
                  children: [
                    Text('Created on  '),
                    Text(
                      formatDate(DateTime.now(), [HH,':',mm]),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}