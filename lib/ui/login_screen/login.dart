// lib/ui/login_screen/login.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/assets_manager.dart';
import '../../core/model/loginModels/LoginResponse.dart';
import '../../core/reusable_components/app_colors_extension.dart';
import '../../core/reusable_components/login_background.dart';
import '../../core/reusable_components/role_selector.dart';
import '../../core/reusable_components/text_field.dart';
import '../../core/reusable_components/toastErrorMsg.dart';
import '../../core/services/loginServices/AuthLoginService.dart';
import '../../core/strings_manager.dart';
import '../home_screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Save token + username
Future<void> saveUserData(String token, String empName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("token", token);
  await prefs.setString("empName", empName);
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late TextEditingController userController;
  late TextEditingController passController;
  late TextEditingController mailController;
  late GlobalKey<FormState> formKey;

  UserRole? selectedRole;
  late FocusNode userFocusNode;

  // Animation controllers (for optional fine control)
  late final AnimationController _switchController;

  static const String emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    userController = TextEditingController();
    passController = TextEditingController();
    mailController = TextEditingController();

    userFocusNode = FocusNode();

    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    mailController.dispose();
    userFocusNode.dispose();
    _switchController.dispose();
    super.dispose();
  }

  bool get _inputsEnabled => selectedRole != null;

  // Helper to convert UserRole -> readable label (keeps it local so we don't rely on role_selector internals)
  String _roleLabel(UserRole? r) {
    if (r == null) return '';
    switch (r) {
      case UserRole.parent:
        return 'Parent';
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.coach:
        return 'Coach';
      case UserRole.admin:
        return 'Admin';
      case UserRole.coordinator:
        return 'Coordinator';
      default:
        return r.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Animations for AnimatedSwitcher slide: bottom <-> top with fade
    Widget transitionBuilder(Widget child, Animation<double> animation) {
      final inOffset = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );
      final outOffset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.04)).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeIn),
      );

      return SlideTransition(
        position: animation.status == AnimationStatus.reverse ? outOffset : inOffset,
        child: FadeTransition(opacity: animation, child: child),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          final result = HitTestResult();
          WidgetsBinding.instance.hitTest(result, details.globalPosition);

          final tappedEditable = result.path.any((hit) {
            final name = hit.target.runtimeType.toString();
            return name.contains("RenderEditable");
          });

          if (!tappedEditable) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // Background
            LoginBackground(showTopBlueBar: false),

            // Language button
            Positioned(
              top: 40.h,
              right: 20.w,
              child: PopupMenuButton<Locale>(
                icon: Icon(Icons.language, color: scheme.elements),
                onSelected: (Locale locale) => context.setLocale(locale),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: Locale('en'), child: Text('🇬🇧 English')),
                  PopupMenuItem(value: Locale('fr'), child: Text('🇫🇷 Français')),
                ],
              ),
            ),

            // Main login card
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Form(
                  key: formKey,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(AssetsManager.logo, width: 150.w),

                        SizedBox(height: 18.h),

                        // Title
                        Text(
                          "welcome".tr(),
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: scheme.textMainBlack,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        // Animated area: role selector OR credentials
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 420),
                          transitionBuilder: (child, animation) => transitionBuilder(child, animation),
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                          child: selectedRole == null
                              ? _buildRoleSelectorCard(scheme) // key differs internally
                              : _buildCredentialsCard(scheme),
                        ),

                        SizedBox(height: 14.h),

                        // Small hint area
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 260),
                          opacity: selectedRole == null ? 1.0 : 0.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              selectedRole == null ? 'Please choose a role to continue' : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.onSurface.withOpacity(0.6),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Login button
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _inputsEnabled ? 1.0 : 0.9,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _inputsEnabled ? scheme.elements : Theme.of(context).disabledColor,
                              minimumSize: Size(330.w, 44.h),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onPressed: !_inputsEnabled ? null : _loginPressed,
                            child: Text(
                              "login".tr(),
                              style: TextStyle(
                                color: _inputsEnabled ? scheme.textMainWhite : scheme.onSurface.withOpacity(0.6),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Role selector card (visible when selectedRole == null)
  Widget _buildRoleSelectorCard(ColorScheme scheme) {
    return Container(
      key: const ValueKey('roleSelector'),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 8)),
        ],
      ),
      width: 360.w,
      child: Column(
        children: [
          RoleSelector(
            initialRole: selectedRole,
            onRoleChanged: (role) {
              setState(() {
                selectedRole = role;
              });
            },
          ),
          SizedBox(height: 8.h),
          Text(
            'Select your role to continue',
            style: TextStyle(fontSize: 13.sp, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  // Credentials card (visible when selectedRole != null)
  Widget _buildCredentialsCard(ColorScheme scheme) {
    return Container(
      key: const ValueKey('credentials'),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 8)),
        ],
      ),
      width: 360.w,
      child: Column(
        children: [
          // small role chip + change button
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999.r),
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.06),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.badge, size: 18.sp, color: scheme.primary),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          _roleLabel(selectedRole), // <-- use helper
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: scheme.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: () {
                  // go back to role selection
                  setState(() {
                    selectedRole = null;
                    userController.clear();
                    passController.clear();
                  });
                },
                child: Text('Change role', style: TextStyle(fontSize: 13.sp)),
              )
            ],
          ),
          SizedBox(height: 12.h),

          // Username field
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: AbsorbPointer(
              absorbing: !_inputsEnabled,
              child: Opacity(
                opacity: _inputsEnabled ? 1.0 : 0.65,
                child: CustomTextField(
                  hint: "enter_user_id".tr(),
                  hintIcon: Icons.person,
                  controller: userController,
                  keyboardType: TextInputType.number,
                  validator: (_) => null,
                  focusNode: userFocusNode,
                  onTap: () {
                    if (!userFocusNode.hasFocus) userFocusNode.requestFocus();
                  },
                ),
              ),
            ),
          ),

          // Password field
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: AbsorbPointer(
              absorbing: !_inputsEnabled,
              child: Opacity(
                opacity: _inputsEnabled ? 1.0 : 0.65,
                child: CustomTextField(
                  hint: "enterPassword".tr(),
                  hintIcon: Icons.lock,
                  controller: passController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "empty_password".tr();
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),

          // Forgot password aligned right
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => _openResetSheet(context, scheme),
                  child: Text(
                    "forget_password".tr(),
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: scheme.textMainBlack),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Forgot password bottom sheet
  void _openResetSheet(BuildContext context, ColorScheme scheme) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: scheme.surface,
        child: Column(
          children: [
            // HEADER
            Container(
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "reset".tr(),
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: scheme.textMainBlack),
                  ),
                  IconButton(icon: Icon(Icons.close, color: scheme.elements), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),

            SizedBox(height: 50.h),

            SizedBox(
              width: 350.w,
              child: CustomTextField(
                hint: "enter_email".tr(),
                hintIcon: Icons.email,
                controller: mailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "empty_email".tr();
                  }
                  if (!RegExp(emailRegex).hasMatch(value)) {
                    return "not_valid_email".tr();
                  }
                  return null;
                },
              ),
            ),

            SizedBox(height: 20.h),

            SizedBox(
              width: 350.w,
              child: Text(
                "reset_note".tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: scheme.textMainBlack),
              ),
            ),

            SizedBox(height: 20.h),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: scheme.elements, minimumSize: Size(330.w, 40.h)),
              onPressed: () {},
              child: Text("reset".tr(), style: TextStyle(color: scheme.textMainWhite, fontSize: 20.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  /// LOGIN LOGIC
  Future<void> _loginPressed() async {
    if (!formKey.currentState!.validate()) return;

    try {
      LoginResponse response = await AuthLoginService.login(
        username: userController.text,
        password: passController.text,
        deviceId: selectedRole.toString(),
        DeviceType: 1,
        fcmToken: "",
      );

      if (response.token != null && response.token!.isNotEmpty) {
        final userData = response.data != null && response.data!.isNotEmpty ? response.data!.first : null;

        final empName = userData?.fatherFullname ?? "";
        final token = response.token ?? "";

        await saveUserData(token, empName);

        Navigator.pushReplacementNamed(
          context,
          HomeScreen.routeName,
          arguments: {"empName": empName, "token": token, "role": selectedRole.toString()},
        );
      } else {
        ToastMsg.toastErrorMsg(context, StringsManager.loginError.tr());
      }
    } catch (e) {
      ToastMsg.toastErrorMsg(context, StringsManager.networkError.tr());
    }
  }
}