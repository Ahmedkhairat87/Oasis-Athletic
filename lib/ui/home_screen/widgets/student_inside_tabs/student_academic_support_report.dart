import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/reusable_components/academic_support_bottom_sheet.dart';
import '../../../../core/reusable_components/academic_support_report_summary_widget.dart';
import '../../../../core/reusable_components/app_background.dart';
import '../../../../core/reusable_components/academic_support_report_card.dart';
import '../../../../core/colors_Manager.dart';

class AcademicReportItem {
  final String id;
  final String subject;
  final DateTime sessionDate;
  final bool isSchoolTask;
  final String teacherName;
  final String teacherComment;

  AcademicReportItem({
    required this.id,
    required this.subject,
    required this.sessionDate,
    required this.isSchoolTask,
    required this.teacherName,
    required this.teacherComment,
  });
}

class StudentAcademicSupportReport extends StatelessWidget {
  const StudentAcademicSupportReport({super.key});

  List<AcademicReportItem> _mockItems() {
    final now = DateTime.now();
    return [
      AcademicReportItem(
        id: '1',
        subject: 'Mathematics - Chapter 4',
        sessionDate: now.subtract(const Duration(days: 1, hours: 3)),
        isSchoolTask: true,
        teacherName: 'Mrs. Elissar',
        teacherComment:
        'Good effort. Please revise exercise 4.2 and submit next class.',
      ),
      AcademicReportItem(
        id: '2',
        subject: 'Arabic - Reading',
        sessionDate: now.subtract(const Duration(days: 2, hours: 2)),
        isSchoolTask: false,
        teacherName: 'Mo3allematy Faten',
        teacherComment:
        'Extra practice assigned — focus on comprehension and pronunciation.',
      ),
      AcademicReportItem(
        id: '3',
        subject: 'Science - Experiment writeup',
        sessionDate: now.subtract(const Duration(days: 5)),
        isSchoolTask: true,
        teacherName: 'Ms. Rania Hamze',
        teacherComment:
        'Detailed report required. Add diagrams and observations.',
      ),
      AcademicReportItem(
        id: '4',
        subject: 'History',
        sessionDate: now.subtract(const Duration(days: 6)),
        isSchoolTask: false,
        teacherName: 'Mohamed Ihab',
        teacherComment:
        'Attended and performed well; increase endurance exercises.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue = isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;

    final Color secondaryBlue = isLight
        ? ColorsManager.primaryGradientEnd
        : ColorsManager.primaryGradientEndDark;

    final items = _mockItems();

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
                    primaryBlue.withOpacity(0.98),
                    secondaryBlue.withOpacity(0.98),
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
          top: false,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 980.w),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface, // OPAQUE
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      final t = value.clamp(0.0, 1.0);
                      return Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, (1 - t) * 10),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReportSummaryTile(
                                label: 'Total',
                                count: items.length,
                                color: ColorsManager.accentSky,
                                elevated: true,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ReportSummaryTile(
                                label: 'School',
                                count: items.where((e) => e.isSchoolTask).length,
                                color: ColorsManager.accentMint,
                                elevated: true,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ReportSummaryTile(
                                label: 'Extra',
                                count: items.length -
                                    items.where((e) => e.isSchoolTask).length,
                                color: ColorsManager.accentCoral,
                                elevated: true,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final it = items[index];

                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration:
                                Duration(milliseconds: 200 + index * 40),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) {
                                  final t = value.clamp(0.0, 1.0);
                                  return Opacity(
                                    opacity: t,
                                    child: Transform.translate(
                                      offset: Offset(0, (1 - t) * 8),
                                      child: child,
                                    ),
                                  );
                                },
                                child: AcademicSupportReportCard(
                                  subject: it.subject,
                                  sessionDate: it.sessionDate,
                                  isSchool: it.isSchoolTask,
                                  onTap: () => _onReportTap(context, it),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onReportTap(BuildContext context, AcademicReportItem item) {
    showTeacherCommentSheet(
      context: context,
      title: item.subject,
      teacherName: item.teacherName,
      comment: item.teacherComment,
    );
  }
}