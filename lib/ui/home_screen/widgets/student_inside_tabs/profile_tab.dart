// lib/ui/student_inside_tabs/profile_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/model/stdLinks/StdFullData.dart';
import '../../../../core/colors_Manager.dart';

// reusable imports
import '../../../../core/reusable_components/profile_tab_conditional_switch.dart';
import '../../../../core/reusable_components/profile_tab_golden_card.dart';
import '../../../../core/reusable_components/profile_tab_labeled_text_field.dart';
import '../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../core/reusable_components/profile_tab_read_only_field.dart';
// ReadOnlyField

class ProfileTab extends StatefulWidget {
  final StdFullData student; // 👈 البيانات الجاية من API

  const ProfileTab({super.key, required this.student});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // Student info (kept as controllers as a data source; not used as editable inside student info)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  // Contact info controllers (editable)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fatherMobileController = TextEditingController();
  final TextEditingController _motherMobileController = TextEditingController();
  final TextEditingController _contactMobileController =
      TextEditingController();
  final TextEditingController _fatherAddressController =
      TextEditingController();
  final TextEditingController _motherAddressController =
      TextEditingController();

  // Emergency contacts (single controllers — your working version uses single emergency fields)
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyMobileController =
      TextEditingController();
  final TextEditingController _emergencyRelationController =
      TextEditingController();

  // Medical
  String _bloodGroup = "";
  bool _hasAllergies = false;
  final TextEditingController _allergyDetailsController =
      TextEditingController();
  bool _pastInjuries = false;
  bool _anySurgery = false;
  final TextEditingController _surgeryDetailsController =
      TextEditingController();

  // Sports & plan
  final TextEditingController _subscriptionPlanController =
      TextEditingController();
  final TextEditingController _athleticProgramController =
      TextEditingController();
  final TextEditingController _primarySportController = TextEditingController();
  final TextEditingController _secondarySportController =
      TextEditingController();

  // ----- EDIT MODE STATE -----
  bool _isEditing = false;

  // Backup store for cancel
  final Map<String, dynamic> _backup = {};

  @override
  void initState() {
    super.initState();

    // Fill read-only info from API (keeps the API logic from your working file)
    _nameController.text = widget.student.stdFirstname ?? '';
    _gradeController.text = widget.student.gradeDesc ?? '';
    _ageController.text =
        (widget.student.ageYears != null)
            ? widget.student.ageYears.toString()
            : '';
    _weightController.text =
        (widget.student.weightKG != null)
            ? widget.student.weightKG.toString()
            : '';
    _heightController.text =
        (widget.student.heightCM != null)
            ? widget.student.heightCM.toString()
            : '';
    _schoolYearController.text = widget.student.schoolYear ?? '';
    _birthDateController.text = widget.student.stdBirthdate ?? '';

    // Contact info
    _emailController.text = widget.student.stdEmail ?? '';
    _fatherMobileController.text = widget.student.fatherMobile ?? '';
    _motherMobileController.text = widget.student.motherMobile ?? '';
    _contactMobileController.text = widget.student.contactMobile ?? '';
    _fatherAddressController.text = widget.student.fatherAddress ?? '';
    _motherAddressController.text = widget.student.motherAddress ?? '';

    // Emergency (your working file didn't populate emergency list — keep empty or map if available)
    // If your API provides emergency fields, map them here.
    // Example (uncomment & adjust keys if available):
    // _emergencyNameController.text = widget.student.emergencyName ?? '';
    // _emergencyMobileController.text = widget.student.emergencyMobile ?? '';
    // _emergencyRelationController.text = widget.student.emergencyRelation ?? '';

    // Medical
    _bloodGroup = widget.student.groupeblood ?? '';
    _hasAllergies = widget.student.allergies ?? false;
    _pastInjuries = widget.student.allergies ?? false;
    _anySurgery = widget.student.allergies ?? false;
    _allergyDetailsController.text = widget.student.allergies ?? '';
    _surgeryDetailsController.text = widget.student.allergies ?? '';

    // Sports — map if API provides those fields
    // _subscriptionPlanController.text = widget.student.subscriptionPlan ?? '';
    // _athleticProgramController.text = widget.student.athleticProgram ?? '';
    // _primarySportController.text = widget.student.primarySport ?? '';
    // _secondarySportController.text = widget.student.secondarySport ?? '';
  }

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

    _emergencyNameController.dispose();
    _emergencyMobileController.dispose();
    _emergencyRelationController.dispose();

    _allergyDetailsController.dispose();
    _surgeryDetailsController.dispose();

    _subscriptionPlanController.dispose();
    _athleticProgramController.dispose();
    _primarySportController.dispose();
    _secondarySportController.dispose();

    super.dispose();
  }

  // --- Helpers: backup / restore ---
  void _backupValues() {
    _backup.clear();
    _backup['email'] = _emailController.text;
    _backup['fatherMobile'] = _fatherMobileController.text;
    _backup['motherMobile'] = _motherMobileController.text;
    _backup['contactMobile'] = _contactMobileController.text;
    _backup['fatherAddress'] = _fatherAddressController.text;
    _backup['motherAddress'] = _motherAddressController.text;

    _backup['emergencyName'] = _emergencyNameController.text;
    _backup['emergencyMobile'] = _emergencyMobileController.text;
    _backup['emergencyRelation'] = _emergencyRelationController.text;

    _backup['bloodGroup'] = _bloodGroup;
    _backup['hasAllergies'] = _hasAllergies;
    _backup['allergyDetails'] = _allergyDetailsController.text;
    _backup['pastInjuries'] = _pastInjuries;
    _backup['anySurgery'] = _anySurgery;
    _backup['surgeryDetails'] = _surgeryDetailsController.text;

    _backup['subscriptionPlan'] = _subscriptionPlanController.text;
    _backup['athleticProgram'] = _athleticProgramController.text;
    _backup['primarySport'] = _primarySportController.text;
    _backup['secondarySport'] = _secondarySportController.text;
  }

  void _restoreBackup() {
    setState(() {
      _emailController.text = _backup['email'] ?? '';
      _fatherMobileController.text = _backup['fatherMobile'] ?? '';
      _motherMobileController.text = _backup['motherMobile'] ?? '';
      _contactMobileController.text = _backup['contactMobile'] ?? '';
      _fatherAddressController.text = _backup['fatherAddress'] ?? '';
      _motherAddressController.text = _backup['motherAddress'] ?? '';

      _emergencyNameController.text = _backup['emergencyName'] ?? '';
      _emergencyMobileController.text = _backup['emergencyMobile'] ?? '';
      _emergencyRelationController.text = _backup['emergencyRelation'] ?? '';

      _bloodGroup = _backup['bloodGroup'] ?? _bloodGroup;
      _hasAllergies = _backup['hasAllergies'] ?? _hasAllergies;
      _allergyDetailsController.text = _backup['allergyDetails'] ?? '';
      _pastInjuries = _backup['pastInjuries'] ?? _pastInjuries;
      _anySurgery = _backup['anySurgery'] ?? _anySurgery;
      _surgeryDetailsController.text = _backup['surgeryDetails'] ?? '';

      _subscriptionPlanController.text = _backup['subscriptionPlan'] ?? '';
      _athleticProgramController.text = _backup['athleticProgram'] ?? '';
      _primarySportController.text = _backup['primarySport'] ?? '';
      _secondarySportController.text = _backup['secondarySport'] ?? '';
    });
  }

  // toggle edit mode
  void _enterEditMode() {
    _backupValues();
    setState(() => _isEditing = true);
  }

  void _cancelEditMode() {
    _restoreBackup();
    setState(() => _isEditing = false);
  }

  // Keep your working API save behaviour: _onSave
  void _onSave() {
    final Color snackColor = ColorsManager.accentMint;
    final snack = SnackBar(
      backgroundColor: snackColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8.w),
          Text('Profile saved', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);

    setState(() => _isEditing = false);
  }

  // multicolor chip helper (visual only, re-themed)
  Widget _goldChip(BuildContext context, String text) {
    final Color primaryBlue =
        Theme.of(context).brightness == Brightness.light
            ? ColorsManager.primaryGradientStart
            : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
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
          border: Border.all(color: primaryBlue.withOpacity(0.7), width: 0.8),
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

  // subtle wrapper for editable sections — disables interaction when not editing
  Widget _editableWrapper({required Widget child}) {
    return AbsorbPointer(
      absorbing: !_isEditing,
      child: Opacity(opacity: _isEditing ? 1.0 : 0.96, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue =
        isLight
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
                              ),
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
                                duration: const Duration(milliseconds: 260),
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

                        // optional action button (kept for other actions)
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert, color: accentPurple),
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

            // ---------- MOVE EDIT CONTROLS HERE ----------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                children: [
                  const Expanded(child: SizedBox()), // push controls to the end
                  if (!_isEditing)
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: _enterEditMode,
                      icon: Icon(Icons.edit, color: accentPurple),
                    )
                  else ...[
                    IconButton(
                      tooltip: 'Cancel',
                      onPressed: _cancelEditMode,
                      icon: Icon(Icons.close, color: Colors.redAccent),
                    ),
                    IconButton(
                      tooltip: 'Save',
                      onPressed: _onSave,
                      icon: Icon(Icons.check, color: ColorsManager.accentMint),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 6.h),

            // 2. Contact information (editable)
            const SectionTitle('Contact information'),
            _animatedSection(
              delayMs: 60,
              child: _editableWrapper(
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
                      // emergency fields (single set)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabeledTextField(
                            controller: _emergencyNameController,
                            hint: 'Emergency name',
                          ),
                          SizedBox(height: 8.h),
                          LabeledTextField(
                            controller: _emergencyRelationController,
                            hint: 'Relation',
                          ),
                          SizedBox(height: 8.h),
                          LabeledTextField(
                            controller: _emergencyMobileController,
                            hint: 'Emergency mobile',
                            keyboardType: TextInputType.phone,
                          ),
                        ],
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
            ),

            SizedBox(height: 12.h),

            // 3. Medical information (editable)
            const SectionTitle('Medical information'),
            _animatedSection(
              delayMs: 120,
              child: _editableWrapper(
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
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
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
                                value:
                                    _bloodGroup.isNotEmpty
                                        ? _bloodGroup
                                        : widget.student.groupeblood,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: primaryBlue,
                                ),
                                items:
                                    const [
                                          'A+',
                                          'A-',
                                          'B+',
                                          'B-',
                                          'AB+',
                                          'AB-',
                                          'O+',
                                          'O-',
                                        ]
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    !_isEditing
                                        ? null
                                        : (v) => setState(
                                          () => _bloodGroup = v ?? _bloodGroup,
                                        ),
                                elevation: 4,
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
                        onChanged: (v) {
                          if (_isEditing) {
                            setState(() => _hasAllergies = v);
                          }
                        },
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
                        onChanged: (v) {
                          if (_isEditing) {
                            setState(() => _pastInjuries = v);
                          }
                        },
                      ),
                      SizedBox(height: 10.h),

                      // Surgery
                      ConditionalSwitch(
                        label: 'Any surgery',
                        value: _anySurgery,
                        onChanged: (v) {
                          if (_isEditing) {
                            setState(() => _anySurgery = v);
                          }
                        },
                        child: LabeledTextField(
                          controller: _surgeryDetailsController,
                          hint: 'Surgery details (if any)',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 4. Sports & Plan (editable)
            const SectionTitle('Sports & Plan'),
            _animatedSection(
              delayMs: 180,
              child: _editableWrapper(
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
            ),

            SizedBox(height: 20.h),

            // Save button (for demonstration) - only active while editing
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
                        return Transform.scale(scale: value, child: child);
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isEditing ? accentCoral : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isEditing ? _onSave : null,
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
}
