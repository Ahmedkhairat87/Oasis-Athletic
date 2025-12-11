// lib/ui/home_screen/widgets/student_inside.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/academicSupport/academic_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/athletics_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/forms_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/meals_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/medical_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/profile_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/schedule_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/model/stdLinks/StdFullData.dart';
import '../../../core/model/stdLinks/StdLinks.dart';
import '../../../core/model/stdLinks/StdMainLinks.dart';
import '../../../core/model/stdLinks/StdSports.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/reusable_components/studentInside_tabbar.dart'; // GoldenTabBar + TabItem
import '../../../core/reusable_components/student_notifier.dart';
import '../../../core/reusable_components/students_inside_tabs.dart'; // StudentTabPages
import '../../../core/reusable_components/student_header.dart';
import '../../../core/services/stdLinksServices/stdLinksServices.dart'; // StudentHeader.fromNotifier

class StudentInside extends StatefulWidget {
  const StudentInside({super.key});

  static const routeName = '/studentInside';

  @override
  State<StudentInside> createState() => _StudentInsideState();
}

class _StudentInsideState extends State<StudentInside> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final ScrollController _tabsScrollController;

  bool loading = true;
  late stdData basicStudent;
  StdLinks? stdLinks;
  StdFullData? student;
  StdSports? studentSports;


  List<StdMainLinks> mainLinks = [];
  List<StdSports> sports = [];
  List<TabItem> dynamicTabs = [];

  int _selectedIndex = 0;

  List<TabItem> get _tabs => dynamicTabs;

  @override
  void initState() {
    super.initState();
    _tabsScrollController = ScrollController();

    /// 1) Load basic student from notifier (RegStd API)
    basicStudent = studentNotifier.value;

    /// 2) Don't manually create StdFullData! (غلط)
    ///    Just wait for API StdLinks
    student = null;

    /// 3) Listen for changes in global notifier
    studentNotifier.addListener(() {
      setState(() {
        basicStudent = studentNotifier.value; // updates name & photo immediately
      });
    });

    /// 4) Load full details from API
    loadStudentData(basicStudent.stdId.toString());
  }

  Future<void> loadStudentData(String stdId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return;

    stdLinks = await StudentLinksService.getStudentLinks(
      token: token,
      stdId: stdId,
    );

    if (stdLinks != null && stdLinks!.stdFullData!.isNotEmpty) {
      setState(() {
        student = stdLinks!.stdFullData!.first;
        updateFullStudent(student!);
        studentSports = stdLinks!.stdSports!.first;

        mainLinks = stdLinks!.stdMainLinks ?? [];
        sports = stdLinks!.stdSports ?? [];
        dynamicTabs = mainLinks.map((e) {
          final emoji = (e.linkIcon ?? "").trim();

          return TabItem(
            title: e.linkName ?? "Untitled",
            icon: Text(
              emoji.isNotEmpty ? emoji : "❓",
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
          );
        }).toList();
        loading = false;

      });
    } else {
      setState(() => loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (student == null || _tabs.isEmpty) {
      return Scaffold(
        body: Center(child: Text("No data found")),
      );
    }

    final pages = mainLinks.map((e) {
      switch (e.linkName?.toLowerCase()) {
        case "profile":
          return ProfileTab(student: student!, stdSports: studentSports!);
        case "academic support":
          return AcademicTab();
        case "academic":
          return AcademicTab();
        case "athletics":
          return AthleticsTab();
        case "meals":
          return MealsTab();
        case "medical":
          return MedicalTab();
        case "forms":
          return FormsTab();
        case "schedule":
          return ScheduleTab();
        default:
          return Center(child: Text("No page found for ${e.linkName}"));
      }
    }).toList();



    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double headerTotal = statusBarHeight + 90;
    final double reservedTop = headerTotal + 46;

    return Scaffold(
      body: AppBackground(
        useAppBarBlur: false,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Stack(
            children: [
              Positioned.fill(
                top: reservedTop.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: StudentTabPages(
                      pages: pages,
                      controller: _pageController,
                      onPageChanged: (i) => setState(() => _selectedIndex = i),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopHeader(context, statusBarHeight, headerTotal),
              ),

              Positioned(
                top: (headerTotal - 46).h,
                left: 12.w,
                right: 12.w,
                child: SizedBox(
                  height: 92.h,
                  child: GoldenTabBar(
                    tabs: _tabs,
                    selectedIndex: _selectedIndex,
                    onTap: (i) => setState(() {
                      _selectedIndex = i;
                      _pageController.jumpToPage(i);
                    }),
                    controller: _tabsScrollController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, double statusBar, double total) {
    return Container(
      height: total,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
            Expanded(
              child: StudentHeaderFromFull(),
            ),
          ],
        ),
      ),
    );
  }
}

