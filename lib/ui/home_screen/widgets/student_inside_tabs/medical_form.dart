// lib/ui/home_screen/widgets/student_inside_tabs/medical_form.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/medical_constants.dart';
import '../../../../core/reusable_components/app_background.dart';

/// Full medical form implementing the fields requested by the user.
/// Styled to match the app theme and uses AppBackground.
/// AppBar style matches StudentInside (white blurred AppBar with black title).
class MedicalForm extends StatefulWidget {
  const MedicalForm({super.key});

  @override
  State<MedicalForm> createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  final _formKey = GlobalKey<FormState>();

  // Basic info
  DateTime? _lastUpdate; // will show last update date/time

  // Blood group radio
  String? _bloodGroup; // values from MedicalConstants.bloodGroups

  // Allergies
  bool _hasAllergies = false;
  final Map<String, bool> _knownAllergies = {
    for (var k in MedicalConstants.allergies) k: false,
  };
  final TextEditingController _typeOfAllergyController = TextEditingController();
  final TextEditingController _severityController = TextEditingController();
  final TextEditingController _specificTreatmentController = TextEditingController();
  final TextEditingController _otherAllergyController = TextEditingController();

  // Chronic conditions
  final TextEditingController _chronicConditionsController = TextEditingController();
  final TextEditingController _chronicTreatmentController = TextEditingController();
  final TextEditingController _chronicEmergencyController = TextEditingController();

  // Past surgeries / hospitalizations
  final TextEditingController _pastSurgeryController = TextEditingController();
  final TextEditingController _hospitalizationReasonController = TextEditingController();
  final TextEditingController _hospitalizationDatesController = TextEditingController();

  // Family medical history
  final TextEditingController _familyHistoryController = TextEditingController();

  // Current medications - dynamic list
  final List<Map<String, TextEditingController>> _medications = [];

  // Immunization
  DateTime? _lastImmunizationDate;
  final TextEditingController _vaccinesReceivedController = TextEditingController();

  // Vision & hearing
  final TextEditingController _visionProblemsController = TextEditingController();
  DateTime? _lastEyeExam;
  bool _visionProblemNo = false;
  bool _visionProblemYes = false;

  final TextEditingController _hearingProblemsController = TextEditingController();
  DateTime? _lastHearingTest;
  bool _hearingProblemNo = false;
  bool _hearingProblemYes = false;

  // Physical activity & sports
  final TextEditingController _activityLimitationsController = TextEditingController();
  final TextEditingController _sportsParticipationController = TextEditingController();
  final TextEditingController _specialEquipmentController = TextEditingController();

  // Mental & behavioral
  final TextEditingController _mentalHistoryController = TextEditingController();
  final TextEditingController _diagnosedConditionsController = TextEditingController();
  final TextEditingController _therapyMedicationController = TextEditingController();
  final TextEditingController _behavioralConcernsController = TextEditingController();
  final TextEditingController _supportNeededController = TextEditingController();

  // Dietary restrictions
  final TextEditingController _specialDietController = TextEditingController();
  final TextEditingController _foodAllergiesController = TextEditingController();

  // Past injuries & surgeries (checkbox lists)
  final Map<String, bool> _pastInjuries = {
    for (var k in MedicalConstants.pastInjuryTypes) k: false,
  };
  bool _pastInjuryNone = false;
  bool _pastInjuryYes = false;
  final TextEditingController _pastInjuriesOtherController = TextEditingController();

  final Map<String, bool> _surgeries = {
    for (var k in MedicalConstants.surgeryTypes) k: false,
  };
  bool _surgeriesNone = false;
  bool _surgeriesYes = false;
  final TextEditingController _surgeriesOtherController = TextEditingController();

  // Date pickers helpers
  Future<void> _pickDate(
      BuildContext context,
      ValueSetter<DateTime?> onPicked, {
        DateTime? initial,
      }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  void initState() {
    super.initState();
    _lastUpdate = DateTime.now();
    // init with one medication row by default
    _addMedicationRow();
  }

  @override
  void dispose() {
    _typeOfAllergyController.dispose();
    _severityController.dispose();
    _specificTreatmentController.dispose();
    _otherAllergyController.dispose();
    _chronicConditionsController.dispose();
    _chronicTreatmentController.dispose();
    _chronicEmergencyController.dispose();
    _pastSurgeryController.dispose();
    _hospitalizationReasonController.dispose();
    _hospitalizationDatesController.dispose();
    _familyHistoryController.dispose();
    _vaccinesReceivedController.dispose();
    _visionProblemsController.dispose();
    _hearingProblemsController.dispose();
    _activityLimitationsController.dispose();
    _sportsParticipationController.dispose();
    _specialEquipmentController.dispose();
    _mentalHistoryController.dispose();
    _diagnosedConditionsController.dispose();
    _therapyMedicationController.dispose();
    _behavioralConcernsController.dispose();
    _supportNeededController.dispose();
    _specialDietController.dispose();
    _foodAllergiesController.dispose();
    _pastInjuriesOtherController.dispose();
    _surgeriesOtherController.dispose();
    for (final row in _medications) {
      row['name']?.dispose();
      row['dosage']?.dispose();
      row['freq']?.dispose();
    }
    super.dispose();
  }

  void _addMedicationRow() {
    setState(() {
      _medications.add({
        'name': TextEditingController(),
        'dosage': TextEditingController(),
        'freq': TextEditingController(),
      });
    });
  }

  void _removeMedicationRow(int index) {
    setState(() {
      _medications[index]['name']?.dispose();
      _medications[index]['dosage']?.dispose();
      _medications[index]['freq']?.dispose();
      _medications.removeAt(index);
    });
  }

  void _saveData() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final meds = _medications
        .map(
          (m) => {
        'medication': m['name']?.text.trim(),
        'dosage': m['dosage']?.text.trim(),
        'frequency': m['freq']?.text.trim(),
      },
    )
        .toList();

    final data = {
      'lastUpdate': _lastUpdate?.toIso8601String(),
      'bloodGroup': _bloodGroup,
      'hasAllergies': _hasAllergies,
      'knownAllergies': _knownAllergies.entries.where((e) => e.value).map((e) => e.key).toList(),
      'typeOfAllergy': _typeOfAllergyController.text.trim(),
      'severity': _severityController.text.trim(),
      'specificTreatment': _specificTreatmentController.text.trim(),
      'otherAllergy': _otherAllergyController.text.trim(),
      'chronicConditions': _chronicConditionsController.text.trim(),
      'chronicTreatmentPlan': _chronicTreatmentController.text.trim(),
      'chronicEmergencyProtocols': _chronicEmergencyController.text.trim(),
      'pastSurgeries': _pastSurgeryController.text.trim(),
      'reasonHospitalization': _hospitalizationReasonController.text.trim(),
      'hospitalizationDates': _hospitalizationDatesController.text.trim(),
      'familyMedicalHistory': _familyHistoryController.text.trim(),
      'currentMedications': meds,
      'lastImmunizationDate': _lastImmunizationDate?.toIso8601String(),
      'vaccinesReceived': _vaccinesReceivedController.text.trim(),
      'visionProblems': _visionProblemsController.text.trim(),
      'lastEyeExam': _lastEyeExam?.toIso8601String(),
      'visionProblemYes': _visionProblemYes,
      'visionProblemNo': _visionProblemNo,
      'hearingProblems': _hearingProblemsController.text.trim(),
      'lastHearingTest': _lastHearingTest?.toIso8601String(),
      'hearingProblemYes': _hearingProblemYes,
      'hearingProblemNo': _hearingProblemNo,
      'activityLimitations': _activityLimitationsController.text.trim(),
      'sportsParticipationLimitations': _sportsParticipationController.text.trim(),
      'specialEquipment': _specialEquipmentController.text.trim(),
      'mentalHistory': _mentalHistoryController.text.trim(),
      'diagnosedConditions': _diagnosedConditionsController.text.trim(),
      'therapyOrMedication': _therapyMedicationController.text.trim(),
      'behavioralConcerns': _behavioralConcernsController.text.trim(),
      'supportNeeded': _supportNeededController.text.trim(),
      'specialDiet': _specialDietController.text.trim(),
      'foodAllergies': _foodAllergiesController.text.trim(),
      'pastInjuryNone': _pastInjuryNone,
      'pastInjuryYes': _pastInjuryYes,
      'pastInjuries': _pastInjuries.entries.where((e) => e.value).map((e) => e.key).toList(),
      'pastInjuriesOther': _pastInjuriesOtherController.text.trim(),
      'surgeriesNone': _surgeriesNone,
      'surgeriesYes': _surgeriesYes,
      'surgeries': _surgeries.entries.where((e) => e.value).map((e) => e.key).toList(),
      'surgeriesOther': _surgeriesOtherController.text.trim(),
    };

    setState(() => _lastUpdate = DateTime.now());

    // TODO: hook this to API/local DB
    // ignore: avoid_print
    print('Medical form saved -> payload:\n$data');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medical form saved successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // helper widget builders to keep the build readable:
  Widget _sectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }

  Widget _smallHint(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
      ),
    );
  }

  Widget _bloodGroupRadios(Color primary) {
    final groups = MedicalConstants.bloodGroups;
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: groups.map((g) {
        final selected = _bloodGroup == g;
        return ChoiceChip(
          label: Text(
            g,
            style: TextStyle(color: selected ? Colors.white : Colors.black),
          ),
          selected: selected,
          onSelected: (_) => setState(() => _bloodGroup = g),
          selectedColor: primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        );
      }).toList(),
    );
  }

  Widget _checkboxListFromMap(Map<String, bool> items) {
    return Column(
      children: items.keys.map((k) {
        return CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(k, style: TextStyle(fontSize: 13.sp)),
          value: items[k],
          activeColor: ColorsManager.accentMint,
          onChanged: (v) => setState(() => items[k] = v ?? false),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    );
  }

  Widget _sectionCard(Widget child, {EdgeInsets? padding}) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color start = isLight ? ColorsManager.primaryGradientStart : ColorsManager.primaryGradientStartDark;
    final Color end = isLight ? ColorsManager.primaryGradientEnd : ColorsManager.primaryGradientEndDark;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [start.withOpacity(0.06), end.withOpacity(0.03)],
        ),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryStart = isLight ? ColorsManager.primaryGradientStart : ColorsManager.primaryGradientStartDark;
    final Color primaryEnd = isLight ? ColorsManager.primaryGradientEnd : ColorsManager.primaryGradientEndDark;

    final lastUpdateDisplay = _lastUpdate != null ? DateFormat.yMd().add_jms().format(_lastUpdate!) : '—';

    return Scaffold(
      // AppBar made to match StudentInside style (white blurred bar + black title)
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Child Medical History',
          style: const TextStyle(color: Colors.black),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.85)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black87),
            onPressed: _saveData,
            tooltip: 'Save form',
          ),
        ],
      ),
      body: AppBackground(
        useAppBarBlur: false, // AppBar already has the blur (same pattern as StudentInside)
        child: SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.86),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.black.withOpacity(0.03)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // header
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Last update :',
                                    style: TextStyle(fontSize: 11.sp),
                                  ),
                                  Text(
                                    lastUpdateDisplay,
                                    style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // content scroll area
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Blood group
                                _sectionHeader('Blood Group'),
                                _sectionCard(
                                  _bloodGroupRadios(primaryStart),
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                ),

                                // Allergies
                                _sectionHeader('1. Allergies'),
                                _sectionCard(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Does the child have allergies?',
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          ChoiceChip(
                                            label: const Text('No'),
                                            selected: !_hasAllergies,
                                            onSelected: (_) => setState(() => _hasAllergies = false),
                                            selectedColor: ColorsManager.accentMint,
                                            backgroundColor: Theme.of(context).colorScheme.surface,
                                          ),
                                          SizedBox(width: 8.w),
                                          ChoiceChip(
                                            label: const Text('Yes'),
                                            selected: _hasAllergies,
                                            onSelected: (_) => setState(() => _hasAllergies = true),
                                            selectedColor: ColorsManager.accentCoral,
                                            backgroundColor: Theme.of(context).colorScheme.surface,
                                          ),
                                        ],
                                      ),
                                      if (_hasAllergies) ...[
                                        SizedBox(height: 8.h),
                                        Text('Known Allergies (select any):', style: TextStyle(fontWeight: FontWeight.w600)),
                                        _checkboxListFromMap(_knownAllergies),
                                        SizedBox(height: 8.h),
                                        TextFormField(controller: _typeOfAllergyController, decoration: _inputDecoration('Type of Allergy')),
                                        SizedBox(height: 8.h),
                                        TextFormField(controller: _severityController, decoration: _inputDecoration('Severity')),
                                        SizedBox(height: 8.h),
                                        TextFormField(controller: _specificTreatmentController, decoration: _inputDecoration('Specific Treatment or Medication'), maxLines: 2),
                                        SizedBox(height: 8.h),
                                        TextFormField(controller: _otherAllergyController, decoration: _inputDecoration('If other (describe)')),
                                      ],
                                    ],
                                  ),
                                ),

                                // Chronic conditions
                                _sectionHeader('2. Chronic Conditions'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      TextFormField(controller: _chronicConditionsController, decoration: _inputDecoration('Condition(s)'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _chronicTreatmentController, decoration: _inputDecoration('Treatment / Management Plan'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _chronicEmergencyController, decoration: _inputDecoration('Emergency Protocols (if any)'), maxLines: 2),
                                    ],
                                  ),
                                ),

                                // Past surgeries / hospitalization
                                _sectionHeader('3. Past Surgeries / Procedures'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      TextFormField(controller: _pastSurgeryController, decoration: _inputDecoration('Surgery Type & Date'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _hospitalizationReasonController, decoration: _inputDecoration('Reason for Hospitalization'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _hospitalizationDatesController, decoration: _inputDecoration('Date(s)')),
                                    ],
                                  ),
                                ),

                                // Family medical history
                                _sectionHeader('4. Family Medical History'),
                                _sectionCard(TextFormField(controller: _familyHistoryController, decoration: _inputDecoration('Relevant Family Medical History'), maxLines: 3)),

                                // Current medications dynamic rows
                                _sectionHeader('5. Current Medications'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      _smallHint('Add medications the child is taking (Medication / Dosage / Frequency)'),
                                      for (var i = 0; i < _medications.length; i++)
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: Row(
                                            children: [
                                              Expanded(flex: 4, child: TextFormField(controller: _medications[i]['name'], decoration: _inputDecoration('Medication'))),
                                              SizedBox(width: 8.w),
                                              Expanded(flex: 3, child: TextFormField(controller: _medications[i]['dosage'], decoration: _inputDecoration('Dosage'))),
                                              SizedBox(width: 8.w),
                                              Expanded(flex: 3, child: TextFormField(controller: _medications[i]['freq'], decoration: _inputDecoration('Frequency'))),
                                              SizedBox(width: 8.w),
                                              Column(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.delete_outline),
                                                    onPressed: _medications.length > 1 ? () => _removeMedicationRow(i) : null,
                                                    tooltip: 'Remove',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: _addMedicationRow, icon: const Icon(Icons.add), label: const Text('Add medication'))),
                                    ],
                                  ),
                                ),

                                // Immunization record
                                _sectionHeader('6. Immunization Record'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => _pickDate(context, (d) => setState(() => _lastImmunizationDate = d), initial: _lastImmunizationDate),
                                              child: InputDecorator(decoration: _inputDecoration('Date of Last Immunization'), child: Text(_lastImmunizationDate != null ? DateFormat.yMMMd().format(_lastImmunizationDate!) : 'Select date')),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _vaccinesReceivedController, decoration: _inputDecoration('Vaccines Received'), maxLines: 2),
                                    ],
                                  ),
                                ),

                                // Vision & Hearing
                                _sectionHeader('7. Vision & Hearing'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      TextFormField(controller: _visionProblemsController, decoration: _inputDecoration('Vision Problems')),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => _pickDate(context, (d) => setState(() => _lastEyeExam = d), initial: _lastEyeExam),
                                              child: InputDecorator(decoration: _inputDecoration('Last Eye Exam Date'), child: Text(_lastEyeExam != null ? DateFormat.yMMMd().format(_lastEyeExam!) : 'dd/mm/yyyy')),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          ToggleButtons(
                                            isSelected: [_visionProblemNo, _visionProblemYes],
                                            onPressed: (idx) {
                                              setState(() {
                                                if (idx == 0) {
                                                  _visionProblemNo = true;
                                                  _visionProblemYes = false;
                                                } else {
                                                  _visionProblemYes = true;
                                                  _visionProblemNo = false;
                                                }
                                              });
                                            },
                                            children: const [
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('No')),
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Yes')),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _hearingProblemsController, decoration: _inputDecoration('Hearing Problems')),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () => _pickDate(context, (d) => setState(() => _lastHearingTest = d), initial: _lastHearingTest),
                                              child: InputDecorator(decoration: _inputDecoration('Last Hearing Test Date'), child: Text(_lastHearingTest != null ? DateFormat.yMMMd().format(_lastHearingTest!) : 'dd/mm/yyyy')),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          ToggleButtons(
                                            isSelected: [_hearingProblemNo, _hearingProblemYes],
                                            onPressed: (idx) {
                                              setState(() {
                                                if (idx == 0) {
                                                  _hearingProblemNo = true;
                                                  _hearingProblemYes = false;
                                                } else {
                                                  _hearingProblemYes = true;
                                                  _hearingProblemNo = false;
                                                }
                                              });
                                            },
                                            children: const [
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('No')),
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Yes')),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Physical activity & sports
                                _sectionHeader('8. Physical Activity & Sports'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      TextFormField(controller: _activityLimitationsController, decoration: _inputDecoration('Limitations on Physical Activity'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _sportsParticipationController, decoration: _inputDecoration('Sports Participation (limitations)'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _specialEquipmentController, decoration: _inputDecoration('Special Equipment Needed')),
                                    ],
                                  ),
                                ),

                                // Mental & Behavioral
                                _sectionHeader('9. Mental & Behavioral Health'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      TextFormField(controller: _mentalHistoryController, decoration: _inputDecoration('Mental Health History'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _diagnosedConditionsController, decoration: _inputDecoration('Diagnosed Conditions'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _therapyMedicationController, decoration: _inputDecoration('Medication or Therapy'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _behavioralConcernsController, decoration: _inputDecoration('Behavioral Concerns'), maxLines: 2),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _supportNeededController, decoration: _inputDecoration('Support Needed')),
                                    ],
                                  ),
                                ),

                                // Dietary restrictions
                                _sectionHeader('10. Dietary Restrictions'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      TextFormField(controller: _specialDietController, decoration: _inputDecoration('Any Special Diet / Nutritional Needs')),
                                      SizedBox(height: 8.h),
                                      TextFormField(controller: _foodAllergiesController, decoration: _inputDecoration('Food Allergies or Sensitivities')),
                                    ],
                                  ),
                                ),

                                // Past injuries
                                _sectionHeader('11. Past Injuries'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          ChoiceChip(
                                            label: const Text('No'),
                                            selected: _pastInjuryNone,
                                            onSelected: (_) => setState(() {
                                              _pastInjuryNone = !_pastInjuryNone;
                                              if (_pastInjuryNone) {
                                                _pastInjuryYes = false;
                                                for (final k in _pastInjuries.keys) {
                                                  _pastInjuries[k] = false;
                                                }
                                              }
                                            }),
                                          ),
                                          SizedBox(width: 8.w),
                                          ChoiceChip(
                                            label: const Text('Yes'),
                                            selected: _pastInjuryYes,
                                            onSelected: (_) => setState(() {
                                              _pastInjuryYes = !_pastInjuryYes;
                                              if (_pastInjuryYes) _pastInjuryNone = false;
                                            }),
                                          ),
                                        ],
                                      ),
                                      if (_pastInjuryYes) ...[
                                        SizedBox(height: 8.h),
                                        Column(children: _pastInjuries.keys.map((k) => CheckboxListTile(dense: true, contentPadding: EdgeInsets.zero, title: Text(k), value: _pastInjuries[k], onChanged: (v) => setState(() => _pastInjuries[k] = v ?? false))).toList()),
                                        TextFormField(controller: _pastInjuriesOtherController, decoration: _inputDecoration('If other')),
                                      ],
                                    ],
                                  ),
                                ),

                                // Surgeries
                                _sectionHeader('12. Surgeries'),
                                _sectionCard(
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          ChoiceChip(
                                            label: const Text('No'),
                                            selected: _surgeriesNone,
                                            onSelected: (_) => setState(() {
                                              _surgeriesNone = !_surgeriesNone;
                                              if (_surgeriesNone) {
                                                _surgeriesYes = false;
                                                for (final k in _surgeries.keys) {
                                                  _surgeries[k] = false;
                                                }
                                              }
                                            }),
                                          ),
                                          SizedBox(width: 8.w),
                                          ChoiceChip(
                                            label: const Text('Yes'),
                                            selected: _surgeriesYes,
                                            onSelected: (_) => setState(() {
                                              _surgeriesYes = !_surgeriesYes;
                                              if (_surgeriesYes) _surgeriesNone = false;
                                            }),
                                          ),
                                        ],
                                      ),
                                      if (_surgeriesYes) ...[
                                        SizedBox(height: 8.h),
                                        Column(children: _surgeries.keys.map((k) => CheckboxListTile(dense: true, contentPadding: EdgeInsets.zero, title: Text(k), value: _surgeries[k], onChanged: (v) => setState(() => _surgeries[k] = v ?? false))).toList()),
                                        TextFormField(controller: _surgeriesOtherController, decoration: _inputDecoration('If other')),
                                      ],
                                    ],
                                  ),
                                ),

                                SizedBox(height: 16.h),
                                // Save / Cancel buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: 14.h),
                                          side: BorderSide(color: Colors.grey.shade300),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                        ),
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: 14.h),
                                          backgroundColor: ColorsManager.accentMint, // brighter color
                                          foregroundColor: Colors.white, // ensures good contrast
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                          elevation: 2,
                                        ),
                                        onPressed: _saveData,
                                        child: Text('Save', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 24.h),
                              ],
                            ),
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
    );
  }
}