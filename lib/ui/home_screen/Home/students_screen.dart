import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors_Manager.dart';
import '../../../core/model/regStdModels/stdData.dart';
import '../../../core/reusable_components/app_background.dart';
import '../../../core/reusable_components/app_colors_extension.dart';
import '../../../core/reusable_components/student_card.dart';
import '../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../widgets/student_inside.dart';

class StudentsScreen extends StatelessWidget {
  final List<stdData> students;

  const StudentsScreen({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = scheme.brightness == Brightness.light;

    final Color primaryBlue = isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;

    final Color secondaryBlue = isLight
        ? ColorsManager.primaryGradientEnd
        : ColorsManager.primaryGradientEndDark;

    return Scaffold(
      extendBodyBehindAppBar: true,

      body: AppBackground(
        //useAppBarBlur: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE + ICON (نفس الحركة)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  final safe = value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: safe,
                    child: Transform.translate(
                      offset: Offset(0, (1 - safe) * 10),
                      child: child,
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            ColorsManager.accentSun,
                            ColorsManager.accentMint,
                            ColorsManager.accentSky,
                            primaryBlue,
                            ColorsManager.accentSun,
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text('🎒',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Students",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: scheme.textMainBlack,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: students.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (_, index) {
                    final student = students[index];

                    return _buildAnimatedStudentCard(
                      context,
                      student: student,
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedStudentCard(
      BuildContext context, {
        required stdData student,
        required int index,
      }) {
    final name = student.stdFirstname ?? 'No Name';
    final photo = student.stdPicture ?? '';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 260 + index * 40),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final double safe = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: safe,
          child: Transform.translate(
            offset: Offset(0, (1 - safe) * 14),
            child: child,
          ),
        );
      },
      child: Center(
        child: StudentCard(
          name: name,
          photo: photo,
          onTap: () {
            // 1. Update the global notifier
            studentNotifier.value = student; // student is StdData

            // 2. Navigate to StudentInside and pass the stdId
            Navigator.pushNamed(
              context,
              StudentInside.routeName,
              arguments: student.stdId.toString(),
            );
          },
        ),
      ),
    );
  }
}
