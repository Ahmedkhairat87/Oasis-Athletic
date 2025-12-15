import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/reusable_components/app_background.dart';
import '../../../../../core/colors_Manager.dart';

class StudentReports extends StatelessWidget {
  static const routeName = '/studentReports';
  const StudentReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          "Academic Support Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManager.primaryGradientStart.withOpacity(0.98),
                    ColorsManager.primaryGradientEnd.withOpacity(0.98),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: AppBackground(
        useAppBarBlur: true,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [

                /// ================= HEADER CARD =================
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundImage: const AssetImage('assets/images/Lucka.jpg'),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Malek",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorsManager.primaryGradientStart,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Class: P4A",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text("School Tasks"),
                          _pill("23", Colors.cyan),
                        ],
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        children: [
                          Text("Extra Tasks"),
                          _pill("12", Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                /// ================= ATTENDANCE =================
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _attendanceRow("Present", "30", Icons.check_circle),
                      SizedBox(height: 6.h),
                      _attendanceRow("Absent", "1", Icons.cancel),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// ================= ANGLAIS =================
                _subjectCard(
                  title: "Anglais",
                  color: Colors.green.shade50,
                  indicators: const [
                    "Autonomie: Good",
                    "Organisation: Good",
                    "Expression: Needs Improvement",
                    "Participation: Needs Improvement",
                  ],
                  comment:
                  "Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data",
                ),

                SizedBox(height: 20.h),

                /// ================= FRANCAIS =================
                _subjectCard(
                  title: "Francais",
                  color: Colors.orange.shade50,
                  indicators: const [
                    "Autonomie: Bon",
                    "Organisation: Excellent",
                    "Expression: Excellent",
                    "Participation: Excellent",
                  ],
                  comment:
                  "Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data , Data",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= SMALL WIDGETS =================

  Widget _pill(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _attendanceRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18.sp),
        SizedBox(width: 6.w),
        Text(
          "$label: $value",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _subjectCard({
    required String title,
    required Color color,
    required List<String> indicators,
    required String comment,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ColorsManager.primaryGradientStart,
            ),
          ),
          SizedBox(height: 12.h),

          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: indicators.map((e) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  e,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 14.h),

          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              comment,
              style: TextStyle(fontSize: 14.sp, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}