// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../Utils/Const/strings.dart';
import '../../../../Utils/variables.dart';

class SearchClass extends StatefulWidget {
  const SearchClass({super.key});

  @override
  State<SearchClass> createState() => _SearchClassState();
}

class _SearchClassState extends State<SearchClass> {
  late String changedText;

  @override
  void initState() {
    super.initState();
    changedText = '';
    textControllerSearch.text = ' ';
  }

//f8217500-e743-1e06-95da-57f3c2a5882a
//34de6db0-e78d-1e06-ad33-2be5425785c4

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        textControllerSearch.clear();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          title: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(children: <Widget>[
              const SizedBox(width: 10.0),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    autofocus: true,
                    controller: textControllerSearch,
                    onChanged: (changedValue) {
                      setState(() {
                        changedText = changedValue.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white
                      ),
                      hintText: "Search",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // IconButton(
              //   iconSize: 35,
              //   icon: Icon(MdiIcons.filter),
              //   onPressed: () {
              //     Builder(builder: ((context) {
              //       return
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                  dropdownColor: Colors.black,
                  focusColor: Colors.white,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  icon: Icon(MdiIcons.filter),
                  iconSize: 35,
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  items: <String>[
                    'Task Name',
                    // 'Created Date',
                    'Priority',
                    'Assign To'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                      onTap: () {
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                    );
                  }).toList(),
                  value: dropdownValue,
                  onChanged: (val) {
                    dropdownValue = val!;
                    print(val);
                  },
                  //       );
                  //     }
                ),
              )
              // );
              //   },
              // )
            ]),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder<DocumentSnapshot>(
          stream: firebaseFirestoreInstance
              .collection('Users')
              .doc(firebaseAuthInstance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data?.data() as Map<String, dynamic>?;

            if (data == null) {
              return const Center(
                child: Text('No data found'),
              );
            }

            // Assuming you have two lists named 'list1' and 'list2'
            var list1 = data['Completed Tasks'] as List? ?? [];
            var list2 = data['Tasks'] as List? ?? [];

            list1.removeWhere(
                (element) => element['Task Name'] == 'First Created');
            list2.removeWhere(
                (element) => element['Task Name'] == 'First Created');

            // Combine list1 and list2
            var combinedList = List.from(list1)..addAll(list2);

            // Filter combinedList based on the search text
            var filteredList = combinedList
                .where((item) => item[dropdownValue]
                    .toString()
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .startsWith(changedText.toLowerCase().replaceAll(' ', '')))
                .toList();
            print('Filtered List : $filteredList');
            if (filteredList.isEmpty) {
              print('true');
              filteredList = combinedList
                  .where((item) => item[dropdownValue]
                      .toString()
                      .toLowerCase()
                      .replaceAll(' ', '')
                      .contains(changedText.toLowerCase().replaceAll(' ', '')))
                  .toList();
              print('Filtered List : $filteredList');
            }
            // You can display the filtered list as needed
            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: const Color.fromARGB(255, 237, 232, 232),
                    elevation: 2,
                    child: SizedBox(
                      height: 55,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              filteredList[index][CONSTANTS.taskNameFirebase],
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(filteredList[index]
                                    [CONSTANTS.isCompletedFirebase]
                                ? 'Completed'
                                : 'Not Completed'),
                          )
                          // trailing: Text(
                          //     filteredList[index][CONSTANTS.isCompletedFirebase])
                          // Text(filteredList[index][CONSTANTS.isCompletedFirebase]),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String dropdownValue = 'Task Name';
}
