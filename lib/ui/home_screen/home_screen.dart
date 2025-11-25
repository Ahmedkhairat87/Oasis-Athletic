// lib/ui/home_screen/home_screen.dart
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/widgets/home_drawer.dart';
import 'package:oasisathletic/ui/home_screen/widgets/student_inside.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/nav_drawer_bloc.dart';
import '../../core/colors_Manager.dart';
import '../../core/model/regStdModels/StdData.dart';
import '../../core/reusable_components/app_background.dart';
import '../../core/reusable_components/app_colors_extension.dart';
import '../../core/reusable_components/student_card.dart';
import '../../core/services/loginServices/getRegStd.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StdData> students = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        setState(() {
          errorMessage = "Missing token. Please log in again.";
          isLoading = false;
        });
        return;
      }

      final result = await Getregstd.getRegStd(
        token: token,
        deviceId: "1",
        DeviceType: 1,
      );

      if (result.data != null && result.data!.isNotEmpty) {
        setState(() {
          students = result.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "No students found.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

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
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentPurple = ColorsManager.accentPurple;

    return BlocProvider(
      create: (_) => NavDrawerBloc(),
      child: Scaffold(
        drawer: const HomeDrawer(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.65),
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Students',
            style: TextStyle(
              color: scheme.textMainBlack,
              fontSize: 18.sp,
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
          iconTheme: IconThemeData(
            color: scheme.textMainBlack,
          ),
        ),
        body: AppBackground(
          useAppBarBlur: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    final double safe = value.clamp(0.0, 1.0);
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
                              accentSun,
                              accentMint,
                              ColorsManager.accentSky,
                              primaryBlue,
                              accentSun,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '🎒',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "student_selection".tr(),
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: isLoading
                        ? Center(
                      key: const ValueKey('loading'),
                      child: _buildLoading(primaryBlue, accentPurple),
                    )
                        : errorMessage != null
                        ? Center(
                      key: const ValueKey('error'),
                      child: _buildError(accentSun),
                    )
                        : _buildStudentsGrid(
                      context,
                      primaryBlue: primaryBlue,
                      accentMint: accentMint,
                      accentPurple: accentPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(Color primaryBlue, Color accentPurple) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                primaryBlue,
                ColorsManager.accentSky,
                ColorsManager.accentMint,
                accentPurple,
                primaryBlue,
              ],
            ),
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Loading students…',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildError(Color accentSun) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        key: const ValueKey('errorWidget'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_rounded,
            size: 40.sp,
            color: accentSun,
          ),
          SizedBox(height: 10.h),
          Text(
            errorMessage ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsGrid(
      BuildContext context, {
        required Color primaryBlue,
        required Color accentMint,
        required Color accentPurple,
      }) {
    return GridView.builder(
      key: const ValueKey('studentsGrid'),
      physics: const BouncingScrollPhysics(),
      itemCount: students.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final student = students[index];
        final name = student.stdFirstname ?? 'No Name';
        final photo = student.stdPicture ?? 'assets/images/logo.png';

        return _buildAnimatedStudentCard(
          context,
          index: index,
          name: name,
          photo: photo,
          student: student,
          accentMint: accentMint,
          primaryBlue: primaryBlue,
          accentPurple: accentPurple,
        );
      },
    );
  }

  Widget _buildAnimatedStudentCard(
      BuildContext context, {
        required int index,
        required String name,
        required String photo,
        required StdData student,
        required Color accentMint,
        required Color primaryBlue,
        required Color accentPurple,
      }) {
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

      // CLEAN CENTERED CARD — NO NUMBER BADGE
      child: Center(
        child: StudentCard(
          name: name,
          photo: photo,
          onTap: () => Navigator.pushNamed(
            context,
            StudentInside.routeName,
            arguments: {'student': student},
          ),
        ),
      ),
    );
  }
}