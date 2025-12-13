// lib/ui/home_screen/widgets/student_inside_tabs/academic_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../core/reusable_components/profile_tab_section_title.dart';
import 'academic_tab_attendance_screen.dart' show TasksListScreen, TaskType;
import 'student_academic_support_report.dart' show StudentAcademicSupportReport;

class AcademicTab extends StatelessWidget {
  const AcademicTab({super.key});

  // Mock numbers (replace with real data)
  final int _mockSchoolTasksCount = 7;
  final int _mockExtraTasksCount = 3;
  final int _attendanceCount = 5;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // Joyful palette
    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: TweenAnimationBuilder<double>(
        // animate from 0 → 1 to avoid overshoot issues with opacity
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          // clamp to [0,1] before using in Opacity
          final double t = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 10),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Academic'),
            SizedBox(height: 12.h),

            GoldCard(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP ROW: Icon + Title
                    Row(
                      children: [
                        // joyful multicolor icon bubble
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                primaryBlue,
                                accentSky,
                                accentMint,
                                accentSun,
                                primaryBlue,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.menu_book,
                            color: Colors.white,
                            size: 28.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Tasks",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // DESCRIPTION
                    Text(
                      "Overview of school and extra tasks assigned to the student",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.85),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // GROUPED BADGES: School + Extra — the whole container is tappable
                    InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const StudentAcademicSupportReport(),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          gradient: LinearGradient(
                            colors: [
                              accentSky.withOpacity(0.16),
                              accentMint.withOpacity(0.14),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: accentMint.withOpacity(0.9),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.10),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header for the grouped area
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Assignments",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ),
                                // small chevron to indicate the whole area is tappable
                                Icon(
                                  Icons.chevron_right,
                                  size: 20.r,
                                  color: accentSun,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            // Badges row — visual only
                            Row(
                              children: [
                                Expanded(
                                  child: _badgeVisual(
                                    context,
                                    label: "School",
                                    count: _mockSchoolTasksCount,
                                    primaryBlue: primaryBlue,
                                    accentSky: accentSky,
                                    accentMint: accentMint,
                                    pillColor: accentPurple,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: _badgeVisual(
                                    context,
                                    label: "Extra",
                                    count: _mockExtraTasksCount,
                                    primaryBlue: primaryBlue,
                                    accentSky: accentSky,
                                    accentMint: accentMint,
                                    pillColor:
                                    ColorsManager.accentCoral,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // Attendance separate — full width clickable row
                    InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const TasksListScreen(selectedType: null),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            colors: [
                              primaryBlue.withOpacity(0.09),
                              accentSky.withOpacity(0.07),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: primaryBlue.withOpacity(0.9),
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // attendance icon colored with a fresh green/blue
                            Icon(
                              Icons.calendar_today,
                              size: 18.r,
                              color: accentMint,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                'Attendance',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: primaryBlue,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    accentPurple,
                                    ColorsManager.accentCoral,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentPurple.withOpacity(0.20),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                '$_attendanceCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Badge visuals (non-tappable — the grouped container handles the tap)
  Widget _badgeVisual(
      BuildContext context, {
        required String label,
        required int count,
        required Color primaryBlue,
        required Color accentSky,
        required Color accentMint,
        required Color pillColor,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentSky.withOpacity(0.14),
            accentMint.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: accentMint.withOpacity(0.9),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pillColor,
                  pillColor.withOpacity(0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: pillColor.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              "$count",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}