// lib/ui/home_screen/widgets/student_inside_tabs/academic_tab_attendance_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/colors_Manager.dart';
import '../../../../../core/reusable_components/app_background.dart';

enum TaskType { school, extra }

class Task {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String teacher;
  final bool attended; // true = attended, false = absent
  final TaskType type;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.teacher,
    required this.attended,
    required this.type,
  });
}

class TasksListScreen extends StatelessWidget {
  final TaskType? selectedType;

  const TasksListScreen({super.key, this.selectedType});

  // mock data for demonstration
  List<Task> _mockTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: 't1',
        title: 'Math homework - Chapter 4',
        date: now.subtract(const Duration(days: 1)),
        time: const TimeOfDay(hour: 16, minute: 0),
        teacher: 'Mrs. Elissar',
        attended: true,
        type: TaskType.school,
      ),
      Task(
        id: 't2',
        title: 'Arabic',
        date: now.subtract(const Duration(days: 2)),
        time: const TimeOfDay(hour: 17, minute: 30),
        teacher: 'Mo3allematy Faten',
        attended: false,
        type: TaskType.extra,
      ),
      Task(
        id: 't3',
        title: 'Science assignment - Experiment',
        date: now.subtract(const Duration(days: 5)),
        time: const TimeOfDay(hour: 14, minute: 0),
        teacher: 'Ms. Rania Hamze',
        attended: true,
        type: TaskType.school,
      ),
      Task(
        id: 't4',
        title: 'Religion',
        date: now.subtract(const Duration(days: 6)),
        time: const TimeOfDay(hour: 18, minute: 0),
        teacher: 'Mr. Magdy Reiad 😂',
        attended: true,
        type: TaskType.extra,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final all = _mockTasks();
    final tasks = selectedType == null
        ? all
        : all.where((t) => t.type == selectedType).toList();

    final Color primaryBlue = isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;
    final Color primaryBlueEnd = isLight
        ? ColorsManager.primaryGradientEnd
        : ColorsManager.primaryGradientEndDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentCoral = ColorsManager.accentCoral;
    final Color accentPurple = ColorsManager.accentPurple;

    final String titleText = selectedType == null
        ? tr('academic_support_attendance')
        : (selectedType == TaskType.school
        ? tr('school_tasks')
        : tr('extra_tasks'));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBlue.withOpacity(0.98),
                    primaryBlueEnd.withOpacity(0.98),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.86),
                        borderRadius: BorderRadius.circular(16.r),
                        border:
                        Border.all(color: Colors.black.withOpacity(0.03)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _summaryCard(
                                  context,
                                  label: tr('total'),
                                  count: tasks.length,
                                  color: primaryBlue,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _summaryCard(
                                  context,
                                  label: tr('attended'),
                                  count:
                                  tasks.where((t) => t.attended).length,
                                  color: accentMint,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Expanded(
                            child: tasks.isEmpty
                                ? Center(
                              child: Text(
                                tr('no_tasks_found'),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                                ),
                              ),
                            )
                                : ListView.separated(
                              physics:
                              const BouncingScrollPhysics(),
                              itemCount: tasks.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 8.h),
                              itemBuilder: (context, i) {
                                final t = tasks[i];
                                final bool attended = t.attended;
                                final Color statusColor = attended
                                    ? accentMint
                                    : accentCoral;

                                return InkWell(
                                  borderRadius:
                                  BorderRadius.circular(14.r),
                                  onTap: () => _showDetail(
                                    context,
                                    t,
                                    primaryBlue,
                                    statusColor,
                                    accentPurple,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: statusColor
                                            .withOpacity(0.65),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            t.title,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight:
                                              FontWeight.w700,
                                              color: primaryBlue,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          attended
                                              ? tr('attended')
                                              : tr('absent'),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight:
                                            FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }

  Widget _summaryCard(BuildContext context,
      {required String label,
        required int count,
        required Color color}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13.sp,
                  color: color,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 6.h),
          Text('$count',
              style: TextStyle(
                  fontSize: 20.sp, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat.jm().format(dt);
  }

  void _showDetail(BuildContext context, Task t, Color primaryBlue,
      Color statusColor, Color accentPurple) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(tr('date'), DateFormat.yMMMd().format(t.date)),
            _detailRow(tr('time'), _formatTime(t.time)),
            _detailRow(tr('teacher'), t.teacher),
            _detailRow(
                tr('status'),
                t.attended
                    ? tr('attended')
                    : tr('absent')),
            _detailRow(
                tr('type'),
                t.type == TaskType.school
                    ? tr('school')
                    : tr('extra')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('close'),
                style: TextStyle(
                    color: accentPurple,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}