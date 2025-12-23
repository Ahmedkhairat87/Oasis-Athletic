import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oasisathletic/ui/drawer/canteen_charge.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/newsLetter/NewsLetterScreen.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/model/regStdModels/SideMenu.dart';
import '../../../drawer/about_us.dart';
import '../../../drawer/appointments.dart';
import '../../../drawer/gallery.dart';
import '../../../drawer/payment_Information.dart';
import '../../../drawer/settings.dart';
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
  int selectedIndex = -1;

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

  void _handleSideMenuTap(BuildContext context, SideMenu item, int index) {
    setState(() {
      selectedIndex = index;
    });

    final String link = (item.lnkNameEn ?? '').toLowerCase();

    Navigator.pop(context);

    if (link.contains('about')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AboutUs()),
      );
    } else if (link.contains('appointment')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Appointments()),
      );
    } else if (link.contains('message')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Messages()),
      );
    } else if (link.contains('newsletter')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewsLetterScreen()),
      );
    } else if (link.contains('canteen')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CanteenCharge()),
      );
    } else if (link.contains('settings')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Settings()),
      );
    }else if (link.contains('gallery')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Gallery()),
      );
    } else if (
    link.contains('payment') ||
        link.contains('fees') ||
        link.contains('invoice')
    ) {
      // ✅ PAYMENT INFORMATION
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentInformation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideMenu = widget.sideMenuList;

    final Color primaryBlue = ColorsManager.primaryGradientStart;
    final Color secondaryBlue = ColorsManager.primaryGradientEnd;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentSun = ColorsManager.accentSun;

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
            _buildHeader(
              context,
              primaryBlue: primaryBlue,
              secondaryBlue: secondaryBlue,
              accentSky: accentSky,
            ),

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
                            fontSize: 14.sp,
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.person_rounded, color: accentSun),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/parentprofile');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),

            Expanded(
              child: sideMenu.isEmpty
                  ? const Center(child: Text("No menu items"))
                  : GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                itemCount: sideMenu.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final item = sideMenu[index];
                  final iconPath = item.lnkPhotoEn ?? "";
                  final bool isSelected = selectedIndex == index;

                  return Card(
                    elevation: isSelected ? 6 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () =>
                          _handleSideMenuTap(context, item, index),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: iconPath.isNotEmpty
                                    ? DecorationImage(
                                  image:
                                  NetworkImage(iconPath),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: iconPath.isEmpty
                                  ? const Center(
                                child: Icon(Icons.menu),
                              )
                                  : null,
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
    );
  }

  Widget _buildHeader(
      BuildContext context, {
        required Color primaryBlue,
        required Color secondaryBlue,
        required Color accentSky,
      }) {
    return SizedBox(
      height: 170.h,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, secondaryBlue, accentSky],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24.r),
          ),
        ),
        padding: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          top: 32.h,
          bottom: 18.h,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.w,
              backgroundColor: Colors.white,
              child: Text(
                'Hi',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Welcome to Oasis Athletics',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}