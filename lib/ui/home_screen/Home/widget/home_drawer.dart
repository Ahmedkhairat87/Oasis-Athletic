import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/colors_Manager.dart';
import '../../../../core/model/regStdModels/SideMenu.dart';
import '../../../drawer/about_us.dart';
import '../../../drawer/appointments.dart';
import '../../MSGScreens/messages.dart';

class HomeDrawer extends StatefulWidget {
  final List<SideMenu> sideMenuList;
  const HomeDrawer({super.key, required this.sideMenuList});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSideMenuTap(BuildContext context, SideMenu item) {
    final link = item.lnkNameEn ?? '';
    Navigator.pop(context); // close drawer first

    if (link.contains('about')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUs()));
    } else if (link.contains('appointments')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Appointments()));
    } else if (link.contains('Messages')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Messages()));
    }
    // Add more navigation rules based on API links
  }

  @override
  Widget build(BuildContext context) {
    final sideMenu = widget.sideMenuList;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color secondaryBlue = ColorsManager.primaryGradientEnd;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentPurple = ColorsManager.accentPurple;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryBlue.withOpacity(0.10),
              accentMint.withOpacity(0.12),
              accentSun.withOpacity(0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // HEADER
            _buildHeader(
                context,
                primaryBlue: primaryBlue,
                secondaryBlue: secondaryBlue,
                accentSky: accentSky),

            // Home + Logout Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(18.r),
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
                    Expanded(
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.home_rounded, color: accentSky),
                        title: Text(
                          'Home',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.logout_rounded, color: accentSun),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Grid of API side menu items with design
            Expanded(
              child: sideMenu.isEmpty
                  ? const Center(
                child: Text(
                  "No menu items",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : GridView.builder(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                itemCount: sideMenu.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final item = sideMenu[index];
                  final title = item.lnkNameEn ?? "No title";
                  final iconPath = item.lnkPhotoEn ?? "";

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.96, end: 1.0),
                    duration:
                    Duration(milliseconds: 220 + index * 40),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      final opacity = value.clamp(0.0, 1.0);
                      return Opacity(
                        opacity: opacity,
                        child: Transform.translate(
                          offset: Offset(0, (1 - opacity) * 10),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () =>
                            _handleSideMenuTap(context, item),
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: iconPath.isNotEmpty
                                    ? DecorationImage(
                                  image:
                                  NetworkImage(iconPath),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                color: iconPath.isEmpty
                                    ? Colors.white12
                                    : null,
                              ),
                              child: iconPath.isEmpty
                                  ? const Icon(Icons.menu,
                                  color: Colors.white, size: 32)
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context,
      {required Color primaryBlue,
        required Color secondaryBlue,
        required Color accentSky}) {
    return SizedBox(
      height: 170.h,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final opacity = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: opacity,
            child: Transform.scale(scale: value, alignment: Alignment.bottomLeft, child: child),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, secondaryBlue, accentSky],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 32.h, bottom: 18.h),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
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
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.95),
                    child: Text(
                      'Hi',
                      style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Welcome to Oasis Athletics',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.86), fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}