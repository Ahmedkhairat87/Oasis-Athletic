import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/model/regStdModels/stdData.dart';
import 'students_screen.dart';
import '../widgets/home_drawer.dart';
import '../../../core/model/regStdModels/SideMenu.dart';


class MainWrapper extends StatefulWidget {
  final List<SideMenu> sideMenuList;
  final List<stdData> students;

  const MainWrapper({
    super.key,
    required this.sideMenuList,
    required this.students,
  });

  @override
  MainWrapperState createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: _buildStyledAppBar(context),
      drawer: HomeDrawer(sideMenuList: widget.sideMenuList),
      body: StudentsScreen(students: widget.students),
    );
  }

  PreferredSizeWidget _buildStyledAppBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0.65),
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        'Students',
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.96),
                  Colors.white.withOpacity(0.92),
                  Colors.white.withOpacity(0.88),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.04),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//
// class MainWrapper extends StatefulWidget {
//   final List<SideMenu> sideMenuList;
//   final List<StdData> students;
//
//   const MainWrapper({
//     super.key,
//     required this.sideMenuList,
//     required this.students,
//   });
//
//   @override
//   MainWrapperState createState() => MainWrapperState();
// }
//
// class MainWrapperState extends State<MainWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Students'),
//       ),
//       drawer: HomeDrawer(sideMenuList: widget.sideMenuList),
//       body: StudentsScreen(students: widget.students),
//     );
//   }
// }