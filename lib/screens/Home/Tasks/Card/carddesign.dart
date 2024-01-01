import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Const/strings.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';

Widget cardDesign(var task, BuildContext context) {
  Color shadowColor;
  if (task[CONSTANTS.priorityFirebase] == CONSTANTS.high) {
    shadowColor = Colors.red;
  } else if (task[CONSTANTS.priorityFirebase] == CONSTANTS.mid) {
    shadowColor = Colors.yellow;
  } else if (task[CONSTANTS.priorityFirebase] == CONSTANTS.low) {
    shadowColor = Colors.green;
  } else {
    shadowColor = Colors.black;
  }
  return Card(
    key: UniqueKey(),
    shadowColor: shadowColor,
    margin: const EdgeInsets.all(16.0),
    elevation: 8.0,
    surfaceTintColor: shadowColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Name:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    task[CONSTANTS.taskNameFirebase],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(Icons.priority_high, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        'Priority: ${task[CONSTANTS.priorityFirebase]}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        task[CONSTANTS.isCompletedFirebase]
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 16.0,
                        color: task[CONSTANTS.isCompletedFirebase]
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Is Completed: ${task[CONSTANTS.isCompletedFirebase] ? 'Yes' : 'No'}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(
                        'Due Date To: ${task['Edited DueDate']}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              const SizedBox(width: 10.0),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 16.0),
                    const SizedBox(height: 4.0),
                    Text(
                      'Created on\n${task[CONSTANTS.createdDateFirebase]}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Spacer(),
                    !task[CONSTANTS.isCompletedFirebase]
                        ? IconButton(
                          iconSize: 30,
                            onPressed: () {
                              showBottomSheet(
                                  backgroundColor: Colors.grey.shade200,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height /
                                          9,
                                      child: StatefulBuilder(
                                          builder: ((context, setState) {
                                        return Column(
                                          children: [
                                            const Text(
                                                'You Want To Delete?',
                                                style: TextStyle(
                                                    fontSize: 20)),
                                            SizedBox(
                                              height:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      90,
                                            ),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: const Text(
                                                      CONSTANTS.no),
                                                ),
                                                const Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    print(task[
                                                        'TimeStamp']);
                                                    context
                                                        .read<
                                                            FirebaseProviderClass>()
                                                        .deleteTask(task[
                                                            'TimeStamp']);
                                                    context
                                                        .read<
                                                            FirebaseProviderClass>()
                                                        .updateData();
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: const Text(
                                                      CONSTANTS.yes),
                                                ),
                                                const Spacer(),
                                              ],
                                            )
                                          ],
                                        );
                                      })),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.delete))
                        : const SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
