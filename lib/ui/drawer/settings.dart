import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/assets_manager.dart';
import '../../core/reusable_components/app_colors_extension.dart';
import '../../core/strings_manager.dart';

class Settings extends StatelessWidget {
  static const routeName = '/settings';
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // drawer: const HomeDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.2),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fullscreen gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.blue.withOpacity(0.05),
                ],
              ),
            ),
          ),

          // Decorative bubble top-left
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),

          // Decorative bubble bottom-right
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue.withOpacity(0.3),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),

          // Main content (scrollable)
          Padding(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 20.h,
              left: 20.w,
              right: 20.w,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Language setting
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language, size: 20),
                            SizedBox(width: 8.w),
                            Text(
                              StringsManager.language,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // French flag
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.borders,
                                ),
                              ),
                              height: 25.h,
                              width: 25.w,
                              child: Image.asset(
                                AssetsManager.france,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // British flag
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.borders,
                                ),
                              ),
                              height: 25.h,
                              width: 25.w,
                              child: Image.asset(
                                AssetsManager.britain,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  /// Theme toggle
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      children: [
                        const Icon(Icons.dark_mode, size: 20),
                        SizedBox(width: 8.w),
                        Text(
                          StringsManager.theme,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  /// Change password
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      children: [
                        const Icon(Icons.password, size: 20),
                        SizedBox(width: 8.w),
                        Text(
                          StringsManager.changePassword,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}