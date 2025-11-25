// lib/ui/home_screen/widgets/home_drawer.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../bloc/drawer_event.dart';
import '../../../bloc/nav_drawer_bloc.dart';
import '../../../bloc/nav_drawer_state.dart';


import '../../../core/colors_Manager.dart';
import '../../../core/strings_manager.dart';
import '../../drawer/messages.dart';
import '../../drawer/sendMessagesScreen.dart'; // <-- used to navigate to Messages

class _NavigationItem {
  final NavItem item;
  final String imagePath;
  _NavigationItem(this.item, this.imagePath);
}

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final List<_NavigationItem> _listItems = [
    // Currently the first card used to be NavItem.homeView — we'll navigate it to Messages.
    _NavigationItem(
      NavItem.homeView,
      "assets/images/side-menu-items/MessagesEN.png",
    ),
    _NavigationItem(
      NavItem.appointmentsView,
      "assets/images/side-menu-items/AppointmentEN.png",
    ),
    _NavigationItem(
      NavItem.busRegView,
      "assets/images/side-menu-items/NewsletterEN.png",
    ),
    _NavigationItem(
      NavItem.canteenChargeView,
      "assets/images/side-menu-items/profileEN.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = scheme.brightness == Brightness.light;

    // joyful palette
    final Color primaryBlue = isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;
    final Color secondaryBlue = isLight
        ? ColorsManager.primaryGradientEnd
        : ColorsManager.primaryGradientEndDark;

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
            // Animated multicolor header
            _buildHeader(
              context,
              primaryBlue: primaryBlue,
              secondaryBlue: secondaryBlue,
              accentSky: accentSky,
            ),

            // QUICK ACTIONS: Home + Logout (in a rounded colorful strip)
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
                        leading: Icon(
                          Icons.home_rounded,
                          color: accentSky,
                        ),
                        title: Text(
                          'Home',
                          style: TextStyle(
                            color: scheme.onSurface.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _handleItemClick(context, NavItem.homeView);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.logout_rounded,
                          color: accentSun,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: scheme.onSurface.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        onTap: () {
                          // TODO: add logout logic if needed
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SETTINGS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                leading: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accentPurple,
                        accentSky,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                title: Text(
                  StringsManager.settings.tr(),
                  style: TextStyle(
                    color: scheme.onSurface.withOpacity(0.9),
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: navigate to settings if available
                },
              ),
            ),

            SizedBox(height: 4.h),

            // MAIN NAV GRID (image-based) with joyful cards + stagger animation
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                itemCount: _listItems.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final item = _listItems[index];
                  return BlocBuilder<NavDrawerBloc, NavDrawerState>(
                    builder: (context, state) => _drawerItemCard(
                      item,
                      state,
                      context,
                      index: index,
                      primaryBlue: primaryBlue,
                      accentMint: accentMint,
                      accentSun: accentSun,
                      accentPurple: accentPurple,
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

  // ======================================================
  // HEADER – joyful gradient with small entrance animation
  // ======================================================
  Widget _buildHeader(
      BuildContext context, {
        required Color primaryBlue,
        required Color secondaryBlue,
        required Color accentSky,
      }) {
    return SizedBox(
      height: 170.h,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          // easeOutBack can overshoot > 1, so clamp for opacity
          final double opacity = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: value,
              alignment: Alignment.bottomLeft,
              child: child,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryBlue,
                secondaryBlue,
                accentSky,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 18.w,
            right: 18.w,
            top: 32.h,
            bottom: 18.h,
          ),
          child: Row(
            children: [
              // playful avatar “balloon”
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
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // greeting + subtitle
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================
  // ITEM CARD (IMAGE-BASED) – joyful, animated cards
  // ======================================================
  Widget _drawerItemCard(
      _NavigationItem data,
      NavDrawerState state,
      BuildContext context, {
        required int index,
        required Color primaryBlue,
        required Color accentMint,
        required Color accentSun,
        required Color accentPurple,
      }) {
    final bool isSelected = state.selectedItem == data.item;

    final Color baseBg = Colors.white.withOpacity(0.92);
    final Color selectedBorder = primaryBlue;
    final Color unselectedBorder = Colors.black12.withOpacity(0.2);

    final Color glow = isSelected ? accentMint : Colors.transparent;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1.0),
      duration: Duration(milliseconds: 220 + index * 40),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // easeOutBack can overshoot > 1, so clamp for opacity
        final double opacity = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, (1 - opacity) * 10),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: isSelected ? 6 : 2,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: glow.withOpacity(0.35),
        clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isSelected
                ? LinearGradient(
              colors: [
                baseBg,
                accentMint.withOpacity(0.16),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: isSelected ? null : baseBg,
            border: Border.all(
              color: isSelected ? selectedBorder : unselectedBorder,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: InkWell(
            onTap: () => _handleItemClick(context, data.item),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Hero(
                  tag: data.imagePath,
                  child: ColorFiltered(
                    colorFilter: isSelected
                        ? ColorFilter.mode(
                      accentSun.withOpacity(0.10),
                      BlendMode.srcATop,
                    )
                        : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      data.imagePath,
                      fit: BoxFit.contain,
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

  /// Handles item clicks from the drawer grid.
  /// Quick fix: when the first card (originally NavItem.homeView) is tapped,
  /// navigate directly to Messages.routeName.
  /// If you later add a NavItem.messages enum value, replace the check below
  /// with `if (item == NavItem.messages) { ... }`.
  void _handleItemClick(BuildContext context, NavItem item) {
    Navigator.pop(context);

    // Quick mapping: the Messages card is currently represented by NavItem.homeView
    if (item == NavItem.homeView) {
      Navigator.pushNamed(context, MessagesScreen.routeName);
      return;
    }

    // Fallback: dispatch to the bloc for other nav items
    BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(item));
  }
}