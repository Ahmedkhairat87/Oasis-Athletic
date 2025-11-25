// lib/ui/home_screen/widgets/student_inside.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/academic_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/athletics_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/forms_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/meals_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/medical_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/profile_tab.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside_tabs/schedule_tab.dart';



import '../../../core/reusable_components/app_background.dart';
import '../../../core/reusable_components/studentInside_tabbar.dart'; // GoldenTabBar + TabItem
import '../../../core/reusable_components/students_inside_tabs.dart'; // StudentTabPages
import '../../../core/reusable_components/student_header.dart'; // StudentHeader.fromNotifier

/// StudentInside screen — header acts as the AppBar (background reaches top edge)
class StudentInside extends StatefulWidget {
  const StudentInside({super.key});

  static const routeName = '/studentInside';

  @override
  State<StudentInside> createState() => _StudentInsideState();
}

class _StudentInsideState extends State<StudentInside> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final ScrollController _tabsScrollController;
  int _selectedIndex = 0;

  // Tab metadata (uses TabItem from studentInside_tabbar.dart)
  final List<TabItem> _tabs = const [
    TabItem(title: "Profile", icon: Icons.person),
    TabItem(title: "Academic", icon: Icons.school),
    TabItem(title: "Athletics", icon: Icons.sports_soccer),
    TabItem(title: "Meals", icon: Icons.restaurant),
    TabItem(title: "Medical", icon: Icons.medical_services),
    TabItem(title: "Forms", icon: Icons.description),
    TabItem(title: "Schedule", icon: Icons.schedule),
  ];

  // Layout constants — tweak these to change sizes. Keep conservative for small screens.
  static const double _headerVisibleHeight = 90; // visible part (below status bar)
  static const double _headerInnerHorizontalPadding = 14.0;
  static const double _floatingTabBarHeight = 92.0; // GoldenTabBar visual height
  static const double _floatingTabBarOverlap = 46.0; // how much tabbar overlaps header

  @override
  void initState() {
    super.initState();
    _tabsScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabsScrollController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutQuad,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const ProfileTab(),
      AcademicTab(),
      const AthleticsTab(),
      const MealsTab(),
      const MedicalTab(),
      const FormsTab(),
      const ScheduleTab(),
    ];

    // Get the status bar height so the header background includes it.
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Total header area background height = statusBar + visible header
    final double headerTotal = statusBarHeight + _headerVisibleHeight;

    // Reserve top space before pages: headerTotal + half of floating tabbar (so it can overlap)
    final double reservedTop = headerTotal + _floatingTabBarOverlap;

    return Scaffold(
      // IMPORTANT: no appBar here — header will act as the AppBar and must touch the top.
      body: AppBackground(
        useAppBarBlur: false,
        // remove inherited top padding so our header can reach the very top
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Stack(
            children: [
              // Main pages area starts after reservedTop. Positioned.fill ensures no overflow.
              Positioned.fill(
                top: reservedTop.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: StudentTabPages(
                      pages: pages,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                    ),
                  ),
                ),
              ),

              // Header background that reaches top (like an AppBar)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: _buildTopHeader(context, statusBarHeight, headerTotal),
              ),

              // Floating tab bar centered and overlapping header bottom.
              Positioned(
                left: 12.w,
                right: 12.w,
                top: (headerTotal - _floatingTabBarOverlap).h,
                child: Center(
                  child: SizedBox(
                    height: _floatingTabBarHeight.h,
                    child: GoldenTabBar(
                      tabs: _tabs,
                      selectedIndex: _selectedIndex,
                      onTap: (i) => _onTabTap(i),
                      controller: _tabsScrollController,
                      tabWidth: 118,
                      iconSize: 26,
                      height: _floatingTabBarHeight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Top header: background reaches the top edge. Content is inset using SafeArea.
  Widget _buildTopHeader(BuildContext context, double statusBarHeight, double headerTotal) {
    final theme = Theme.of(context);
    return ClipRRect(
      // keep no rounded corners so edges touch screen sides like AppBar
      borderRadius: BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: headerTotal.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.78),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          // Use SafeArea to keep content below the status bar while background remains full-bleed.
          child: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _headerInnerHorizontalPadding.w),
              child: Row(
                children: [
                  // back button on the left (simple, no extra actions)
                  SizedBox(
                    width: 44.w,
                    height: 44.h,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: Icon(Icons.arrow_back, size: 22.r, color: theme.iconTheme.color),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Student header (avatar + name + grade) — fills remaining space
                  Expanded(child: StudentHeader.fromNotifier()),

                  // right spacer (keeps visual balance)
                  SizedBox(width: 12.w),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}