// lib/ui/student_inside_tabs/profile_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/colors_Manager.dart';

// reusable imports
import '../../../../core/reusable_components/profile_tab_conditional_switch.dart';
import '../../../../core/reusable_components/profile_tab_emergency_contact_field.dart';
import '../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../core/reusable_components/profile_tab_labeled_text_field.dart';
import '../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../core/reusable_components/profile_tab_read_only_field.dart'; // ReadOnlyField

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // Student info (kept as controllers as a data source; not used as editable inside student info)
  final TextEditingController _nameController =
  TextEditingController(text: 'Malek Mahmoud Khairat');
  final TextEditingController _gradeController =
  TextEditingController(text: 'P4D');
  final TextEditingController _ageController =
  TextEditingController(text: '9 Years Old');
  final TextEditingController _weightController =
  TextEditingController(text: '45 kg');
  final TextEditingController _heightController =
  TextEditingController(text: '100 cm');
  final TextEditingController _schoolYearController =
  TextEditingController(text: '2025/2026');
  final TextEditingController _birthDateController =
  TextEditingController(text: '06/10/2016');

  // Contact info controllers (editable)
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _fatherMobileController =
  TextEditingController(text: '');
  final TextEditingController _motherMobileController =
  TextEditingController(text: '');
  final TextEditingController _contactMobileController =
  TextEditingController(text: '');
  final TextEditingController _fatherAddressController =
  TextEditingController(text: '');
  final TextEditingController _motherAddressController =
  TextEditingController(text: '');

  // Emergency contacts (3)
  final List<TextEditingController> _emergencyName =
  List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _emergencyMobile =
  List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _emergencyRelation =
  List.generate(3, (_) => TextEditingController());

  // Medical
  String _bloodGroup = 'O+';
  bool _hasAllergies = false;
  final TextEditingController _allergyDetailsController =
  TextEditingController();
  bool _pastInjuries = false;
  bool _anySurgery = false;
  final TextEditingController _surgeryDetailsController =
  TextEditingController();

  // Sports & plan
  final TextEditingController _subscriptionPlanController =
  TextEditingController(text: 'Staff');
  final TextEditingController _athleticProgramController =
  TextEditingController(text: 'PYP Football');
  final TextEditingController _primarySportController =
  TextEditingController(text: 'Football');
  final TextEditingController _secondarySportController =
  TextEditingController(text: 'Swimming');

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _schoolYearController.dispose();
    _birthDateController.dispose();

    _emailController.dispose();
    _fatherMobileController.dispose();
    _motherMobileController.dispose();
    _contactMobileController.dispose();
    _fatherAddressController.dispose();
    _motherAddressController.dispose();

    for (final c in _emergencyName) {
      c.dispose();
    }
    for (final c in _emergencyMobile) {
      c.dispose();
    }
    for (final c in _emergencyRelation) {
      c.dispose();
    }

    _allergyDetailsController.dispose();
    _surgeryDetailsController.dispose();

    _subscriptionPlanController.dispose();
    _athleticProgramController.dispose();
    _primarySportController.dispose();
    _secondarySportController.dispose();

    super.dispose();
  }

  // multicolor chip helper (visual only, re-themed)
  Widget _goldChip(BuildContext context, String text) {
    final Color primaryBlue = Theme.of(context).brightness == Brightness.light
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          gradient: LinearGradient(
            colors: [
              primaryBlue.withOpacity(0.12),
              accentMint.withOpacity(0.18),
              accentSky.withOpacity(0.14),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: primaryBlue.withOpacity(0.7),
            width: 0.8,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  // small read-only chips row (age / weight / height)
  Widget _readOnlyChips(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _goldChip(context, _ageController.text),
        _goldChip(context, _weightController.text),
        _goldChip(context, _heightController.text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue = isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;
    final Color accentCoral = ColorsManager.accentCoral;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.96, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          // ✅ clamp so opacity is always 0.0–1.0
          final double safe = value.clamp(0.0, 1.0);

          return Opacity(
            opacity: safe,
            child: Transform.translate(
              offset: Offset(0, (1 - safe) * 12),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Student information (READ-ONLY)
            const SectionTitle('Student information'),
            _animatedSection(
              delayMs: 0,
              child: GoldCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // top row: avatar + name + optional action
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar with joyful multicolor ring
                        Container(
                          width: 92.w,
                          height: 92.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                primaryBlue,
                                accentSky,
                                accentMint,
                                accentSun,
                                accentCoral,
                                primaryBlue,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/Lucka.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // name and small meta
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.95, end: 1.0),
                                duration:
                                const Duration(milliseconds: 260),
                                curve: Curves.easeOutBack,
                                builder: (context, v, child) {
                                  return Transform.scale(
                                    scale: v,
                                    alignment: Alignment.centerLeft,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  _nameController.text,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // Grade on its own line
                              ReadOnlyField(
                                label: 'Grade',
                                value: _gradeController.text,
                                preferredLabelWidth: 88,
                              ),
                              SizedBox(height: 6.h),
                              // School year under grade
                              ReadOnlyField(
                                label: 'School year',
                                value: _schoolYearController.text,
                                preferredLabelWidth: 110,
                              ),
                            ],
                          ),
                        ),

                        // optional action button
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color: accentPurple,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // chips row and birth date below
                    _readOnlyChips(context),
                    SizedBox(height: 10.h),
                    ReadOnlyField(
                      label: 'Birth date',
                      value: _birthDateController.text,
                      preferredLabelWidth: 110,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 2. Contact information (editable)
            const SectionTitle('Contact information'),
            _animatedSection(
              delayMs: 60,
              child: GoldCard(
                child: Column(
                  children: [
                    LabeledTextField(
                      controller: _emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            controller: _fatherMobileController,
                            hint: 'Father mobile',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: LabeledTextField(
                            controller: _motherMobileController,
                            hint: 'Mother mobile',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    LabeledTextField(
                      controller: _contactMobileController,
                      hint: 'Contact mobile',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(3, (i) {
                        return EmergencyContactField(
                          index: i,
                          nameController: _emergencyName[i],
                          mobileController: _emergencyMobile[i],
                          relationController: _emergencyRelation[i],
                        );
                      }),
                    ),
                    SizedBox(height: 6.h),
                    LabeledTextField(
                      controller: _fatherAddressController,
                      hint: 'Father address',
                    ),
                    SizedBox(height: 8.h),
                    LabeledTextField(
                      controller: _motherAddressController,
                      hint: 'Mother address',
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 3. Medical information (editable)
            const SectionTitle('Medical information'),
            _animatedSection(
              delayMs: 120,
              child: GoldCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blood group dropdown
                    Row(
                      children: [
                        Text(
                          'Blood group',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: LinearGradient(
                              colors: [
                                accentMint.withOpacity(0.18),
                                accentSky.withOpacity(0.16),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _bloodGroup,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: primaryBlue,
                              ),
                              items: const [
                                'A+',
                                'A-',
                                'B+',
                                'B-',
                                'AB+',
                                'AB-',
                                'O+',
                                'O-'
                              ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                                  .toList(),
                              onChanged: (v) => setState(
                                    () => _bloodGroup = v ?? _bloodGroup,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Allergies switch + conditional textbox
                    ConditionalSwitch(
                      label: 'Allergies',
                      value: _hasAllergies,
                      onChanged: (v) => setState(() => _hasAllergies = v),
                      child: LabeledTextField(
                        controller: _allergyDetailsController,
                        hint: 'Allergy details (if any)',
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Past injuries
                    ConditionalSwitch(
                      label: 'Past injuries',
                      value: _pastInjuries,
                      onChanged: (v) => setState(() => _pastInjuries = v),
                    ),
                    SizedBox(height: 10.h),

                    // Surgery
                    ConditionalSwitch(
                      label: 'Any surgery',
                      value: _anySurgery,
                      onChanged: (v) => setState(() => _anySurgery = v),
                      child: LabeledTextField(
                        controller: _surgeryDetailsController,
                        hint: 'Surgery details (if any)',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 4. Sports & Plan (editable)
            const SectionTitle('Sports & Plan'),
            _animatedSection(
              delayMs: 180,
              child: GoldCard(
                child: Column(
                  children: [
                    LabeledTextField(
                      controller: _subscriptionPlanController,
                      hint: 'Subscription plan',
                    ),
                    SizedBox(height: 8.h),
                    LabeledTextField(
                      controller: _athleticProgramController,
                      hint: 'Athletic program',
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            controller: _primarySportController,
                            hint: 'Primary sport',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: LabeledTextField(
                            controller: _secondarySportController,
                            hint: 'Secondary sport',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Save button (for demonstration)
            _animatedSection(
              delayMs: 220,
              child: Row(
                children: [
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.94, end: 1.0),
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentCoral,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _onSave,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // Small helper to give each GoldCard a subtle entrance animation
  Widget _animatedSection({required int delayMs, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1.0),
      duration: Duration(milliseconds: 260 + delayMs),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        // ✅ clamp here too to keep opacity safe
        final double safe = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: safe,
          child: Transform.translate(
            offset: Offset(0, (1 - safe) * 10),
            child: child,
          ),
        );
      },
    );
  }

  void _onSave() {
    final Color snackColor = ColorsManager.accentMint;
    final snack = SnackBar(
      backgroundColor: snackColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8.w),
          Text(
            'Profile saved',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}