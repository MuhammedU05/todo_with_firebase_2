

// // import '../../../Utils/custom/bottomnavigation bar/bottomnavbar.dart';

// // import '../../../Utils/custom/bottomnavigation bar/util2.dart';

// // import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// // Widget child = const TaskScreen();
// import '../../../Utils/custom/bottomnavigation bar/bottomnav_lib.dart';
// import '../../../Utils/custom/bottomnavigation bar/bottomnavbar.dart';
// import '../Complete/completed.dart';
// import '../Group/groupscreen.dart';
// import '../Tasks/AppBar/appbar.dart';
// import '../Tasks/Search Screen/searchscreen.dart';
// import '../Tasks/task.dart';

// int selectedIndex = 1;
// Widget? _child;

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   final int _page = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarClass(context) as AppBar,
//       body: _child,
//       // backgroundColor: selectedIndex == 0
//       //     ? COLORCONST.greenish
//       //     : selectedIndex == 1
//       //         ? COLORCONST.lightBlueShade // const Color(0xFF4285F4)
//       //         : selectedIndex == 2
//       //             ? COLORCONST.white // const Color(0xFFEC4134)
//       //             : COLORCONST.yellowShade, // const Color(0xFFFCBA02),
//       bottomNavigationBar: FluidNavBar(
//         icons: [
//           FluidNavBarIcon(
//               // backgroundColor:Colors.transparent,
//               icon: Icons.group,
//               backgroundColor: const Color(0xFF4285F4),
//               extras: {"label": "home"}),
//           FluidNavBarIcon(
//               icon: Icons.task,
//               backgroundColor: const Color(0xFFEC4134),
//               extras: {"label": "bookmark"}),
//           FluidNavBarIcon(
//               icon: Icons.search,
//               backgroundColor: const Color(0xFFFCBA02),
//               extras: {"label": "partner"}),
//           FluidNavBarIcon(
//               icon: Icons.done_outline_outlined,
//               backgroundColor: const Color(0xFF34A950),
//               // backgroundColor: const Color(0xFF34A950),
//               extras: {"label": "conference"}),
//         ],
//         onChange: _handleNavigationChange,
//         style: const FluidNavBarStyle(
//             barBackgroundColor: Color(0xFFFB5C66),
//             iconBackgroundColor: Colors.white,
//             iconSelectedForegroundColor: Color(0xFFFB5C66),
//             iconUnselectedForegroundColor: Colors.black,
//             // barBackgroundColor: Colors.black,
//             // iconBackgroundColor: Colors.transparent,
//             // iconSelectedForegroundColor: Colors.transparent,
//             // iconUnselectedForegroundColor: Colors.black,
//             ),
//         scaleFactor: 1.5,
//         defaultIndex: 1,
//         itemBuilder: (icon, item) => Semantics(
//           label: icon.extras!["label"],
//           child: item,
//         ),
//       ),
//     );
//   }

//   Widget bottomItem(
//       {required int index, required String title, required IconData icon}) {
//     if (index == _page) {
//       return Icon(
//         icon,
//         size: 26,
//         color: Colors.black,
//       );
//     } else {
//       return Padding(
//         padding: const EdgeInsets.only(top: 6.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Icon(
//               icon,
//               size: 22,
//               color: Colors.black,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               title,
//               style: const TextStyle(color: Colors.red),
//             )
//           ],
//         ),
//       );
//     }
//   }

//   void _handleNavigationChange(int index) {
//     setState(() {
//       switch (index) {
//         case 0:
//           selectedIndex = index;
//           _child = const GroupScreen();
//           break;
//         case 1:
//           selectedIndex = index;
//           _child = const TaskScreen();
//           break;
//         case 2:
//           selectedIndex = index;
//           _child =  const SearchClass() as Widget?;
//           break;
//         case 3:
//           selectedIndex = index;
//           _child = const TaskScreenCompleted();
//           break;
//       }
//       //       const GroupScreen(),
//       // const TaskScreen(),
//       // const TaskScreenCompleted(),
//       // const SearchClass(),
//       _child = AnimatedSwitcher(
//         switchInCurve: Curves.easeOut,
//         switchOutCurve: Curves.easeIn,
//         duration: const Duration(milliseconds: 500),
//         child: _child,
//       );
//     });
//   }
// }
