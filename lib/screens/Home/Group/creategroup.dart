import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase_2/Utils/Provider/firebaseprovider.dart';
import 'package:todo_with_firebase_2/Utils/variables.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  bool _showUserList = false;
  final TextEditingController _groupNameController = TextEditingController();
  final _myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<FirebaseProviderClass>().getAllUser();
    _showUserList = false;
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    //...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Group'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                TextField(
                  autofocus: true,
                  controller: _groupNameController,
                  focusNode: _myFocusNode,
                  decoration: const InputDecoration(labelText: 'Group Name'),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.lightGreen,
                    ),
                    child: Row(children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.people_alt_rounded),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('Add Users'),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(_showUserList
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_outlined),
                      ),
                    ]),
                  ),
                  onTap: () {
                    setState(() {
                      _myFocusNode.unfocus();
                      _showUserList = !_showUserList;
                      // context.read<FirebaseProviderClass>().getAllUser();
                    });
                  },
                ),

                const SizedBox(
                  height: 10,
                ),
                !_showUserList
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 1.6,
                      )
                    : SizedBox(
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //       strokeAlign: BorderSide.strokeAlignOutside,
                        //         color: Colors.grey.shade300.withOpacity(.5)),
                        //     shape: BoxShape.rectangle, // to make it a rectangle
                        //     boxShadow: const [
                        //       // only want the shadow on one side
                        //       BoxShadow(
                        //           blurRadius: 14.0, // hardness of the shadow
                        //           spreadRadius:
                        //               2.0, // how far out the shadow goes as a fraction of the size of the box
                        //           color: Color.fromARGB(
                        //               100, 0, 0, 0) // shadow color
                        //           )
                        //     ]),
                        height: MediaQuery.of(context).size.height / 1.6,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: ((context, index) {
                              print('$allUsersDatas');
                              return Card(
                                  child: ListTile(
                                title: Text('Member'),
                                leading: Padding(
                                  padding: const EdgeInsets.only(),
                                  child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: Image.network(
                                              'https://lh3.googleusercontent.com/a/ACg8ocLSGGjLUZ5K3WO-FHo7LO7DOZKfOINJM9NWTOT6efrhlrQ=s96-c')
                                          .image),
                                ),
                              ));
                            })),
                        // ),
                      ),
                //Create Group & Cancel Button
                Row(mainAxisSize: MainAxisSize.min, children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (_) => Colors.green)),
                      child: const Text('Create Group',
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 14),
                  OutlinedButton(
                      onPressed: () {
                        _groupNameController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'))
                ])
              ],
            ),
          ),
        ));
  }
}
