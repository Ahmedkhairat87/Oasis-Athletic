// lib/ui/home_screen/widgets/student_inside_tabs/nutrition_form.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/colors_Manager.dart';
import '../../../../core/reusable_components/app_background.dart';

enum BreakfastFreq { always, sometimes, never }
enum YesNo { no, yes }
enum SnackFeeling { snack, hungry }
enum RiceAmount { same, less, more }
enum EatingSpeed { fast, moderate, slow }
enum EatFruitDrink { eat, drink }

class NutritionForm extends StatefulWidget {
  const NutritionForm({super.key});

  @override
  State<NutritionForm> createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _lastUpdate;

  // Text controllers
  final TextEditingController _favoriteSnackController = TextEditingController();
  final TextEditingController _dislikedFoodsController = TextEditingController();
  final TextEditingController _cupsPerDayController = TextEditingController();
  BreakfastFreq? _breakfastFreq;

  // Snacking & night eating
  final TextEditingController _toastTypeController = TextEditingController();
  final TextEditingController _sugarTeaspoonsController = TextEditingController();
  RiceAmount? _riceAmount;
  YesNo? _eatBeforeSleep;
  YesNo? _isNightEater;
  SnackFeeling? _nightHungerOrSnack;
  String? _whenSnack; // "After breakfast" / "After lunch" / "Between both"

  // Sleep & eating
  final TextEditingController _avgSleepHoursController = TextEditingController();
  EatingSpeed? _eatingSpeed;

  // Vegetables & fruits
  final TextEditingController _vegFreqController = TextEditingController();
  final TextEditingController _vegListController = TextEditingController();
  final TextEditingController _fruitFreqController = TextEditingController();
  final TextEditingController _fruitListController = TextEditingController();
  EatFruitDrink? _eatOrDrinkFruit;
  final TextEditingController _candyController = TextEditingController();
  // Cooking fat - booleans
  bool _usesOil = false;
  bool _usesButter = false;
  bool _usesMargarine = false;

  @override
  void initState() {
    super.initState();
    _lastUpdate = DateTime.now();
    // sensible defaults
    _breakfastFreq = BreakfastFreq.always;
    _riceAmount = RiceAmount.same;
    _eatBeforeSleep = YesNo.no;
    _isNightEater = YesNo.no;
    _nightHungerOrSnack = SnackFeeling.snack;
    _eatingSpeed = EatingSpeed.moderate;
    _eatOrDrinkFruit = EatFruitDrink.eat;
    _whenSnack = 'After breakfast';
    _cupsPerDayController.text = '0';
    _sugarTeaspoonsController.text = '0';
    _avgSleepHoursController.text = '8.0';
  }

  @override
  void dispose() {
    _favoriteSnackController.dispose();
    _dislikedFoodsController.dispose();
    _cupsPerDayController.dispose();
    _toastTypeController.dispose();
    _sugarTeaspoonsController.dispose();
    _avgSleepHoursController.dispose();
    _vegFreqController.dispose();
    _vegListController.dispose();
    _fruitFreqController.dispose();
    _fruitListController.dispose();
    _candyController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
    );
  }

  Widget _sectionCard(Widget child) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color start = isLight ? ColorsManager.primaryGradientStart : ColorsManager.primaryGradientStartDark;
    final Color end = isLight ? ColorsManager.primaryGradientEnd : ColorsManager.primaryGradientEndDark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: [start.withOpacity(0.08), end.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: child,
    );
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix form errors'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    final payload = {
      'lastUpdate': _lastUpdate?.toIso8601String(),
      'favoriteSnack': _favoriteSnackController.text.trim(),
      'dislikedFoods': _dislikedFoodsController.text.trim(),
      'drinksWater': (_cupsPerDayController.text.trim().isNotEmpty && int.tryParse(_cupsPerDayController.text.trim()) != null),
      'cupsPerDay': int.tryParse(_cupsPerDayController.text.trim()) ?? 0,
      'breakfastFreq': _breakfastFreq?.name,
      'toastType': _toastTypeController.text.trim(),
      'sugarTeaspoonsPerDay': int.tryParse(_sugarTeaspoonsController.text.trim()) ?? 0,
      'riceAmount': _riceAmount?.name,
      'eatBeforeSleep': _eatBeforeSleep?.name,
      'isNightEater': _isNightEater?.name,
      'nightHungerOrSnack': _nightHungerOrSnack?.name,
      'whenSnack': _whenSnack,
      'avgSleepHours': double.tryParse(_avgSleepHoursController.text.trim()) ?? 0.0,
      'eatingSpeed': _eatingSpeed?.name,
      'vegFreq': _vegFreqController.text.trim(),
      'vegList': _vegListController.text.trim(),
      'fruitFreq': _fruitFreqController.text.trim(),
      'fruitList': _fruitListController.text.trim(),
      'eatOrDrinkFruit': _eatOrDrinkFruit?.name,
      'candy': _candyController.text.trim(),
      'usesOil': _usesOil,
      'usesButter': _usesButter,
      'usesMargarine': _usesMargarine,
    };

    // for now print and show snackbar. Replace with API or local DB save later.
    // ignore: avoid_print
    print('Nutrition form saved: $payload');

    setState(() {
      _lastUpdate = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nutrition form saved'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lastUpdateDisplay = _lastUpdate != null ? DateFormat.yMd().add_jms().format(_lastUpdate!) : '—';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Nutrition Form', style: TextStyle(color: Colors.black)),
        flexibleSpace: ClipRect(
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(color: Colors.white.withOpacity(0.85))),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save, color: Colors.black87), onPressed: _saveForm),
        ],
      ),
      body: AppBackground(
        useAppBarBlur: false,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: Colors.black.withOpacity(0.03)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // header
                        Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('Last update :', style: TextStyle(fontSize: 11.sp)),
                            Text(lastUpdateDisplay, style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade700)),
                          ])),
                        ]),
                        SizedBox(height: 12.h),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Food Preferences'),
                                _sectionCard(Column(children: [
                                  TextFormField(controller: _favoriteSnackController, decoration: _inputDecoration('Favorite snack the child loves')),
                                  SizedBox(height: 8.h),
                                  TextFormField(controller: _dislikedFoodsController, decoration: _inputDecoration('Food they don’t like or refuse')),
                                ])),

                                _sectionHeader('Water & Breakfast'),
                                _sectionCard(Column(children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          controller: _cupsPerDayController,
                                          decoration: _inputDecoration('How many cups per day?'),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        flex: 5,
                                        child: DropdownButtonFormField<BreakfastFreq>(
                                          isExpanded: true,
                                          initialValue: _breakfastFreq,
                                          decoration: _inputDecoration('Do you have breakfast?'),
                                          items: BreakfastFreq.values.map((f) {
                                            final label = {
                                              BreakfastFreq.always: 'Always',
                                              BreakfastFreq.sometimes: 'Sometimes',
                                              BreakfastFreq.never: 'Never',
                                            }[f]!;
                                            return DropdownMenuItem(value: f, child: Text(label));
                                          }).toList(),
                                          onChanged: (BreakfastFreq? v) => setState(() => _breakfastFreq = v),
                                        ),
                                      ),
                                    ],
                                  ),
                                ])),

                                _sectionHeader('Snacking & Night Eating'),
                                _sectionCard(Column(children: [
                                  TextFormField(controller: _toastTypeController, decoration: _inputDecoration('Toasts / Balady bread (what kind?)')),
                                  SizedBox(height: 8.h),
                                  Row(children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _sugarTeaspoonsController,
                                        decoration: _inputDecoration('Teaspoons of sugar per day'),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: DropdownButtonFormField<RiceAmount>(
                                        isExpanded: true,
                                        initialValue: _riceAmount,
                                        decoration: _inputDecoration('How many rice for lunch?'),
                                        items: RiceAmount.values.map((r) {
                                          final label = {
                                            RiceAmount.same: 'Same',
                                            RiceAmount.less: 'Less',
                                            RiceAmount.more: 'More',
                                          }[r]!;
                                          return DropdownMenuItem(value: r, child: Text(label));
                                        }).toList(),
                                        onChanged: (RiceAmount? v) => setState(() => _riceAmount = v),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(height: 8.h),
                                  Row(children: [
                                    Expanded(
                                      child: DropdownButtonFormField<YesNo>(
                                        isExpanded: true,
                                        initialValue: _eatBeforeSleep,
                                        decoration: _inputDecoration('Do you eat before sleep every day?'),
                                        items: YesNo.values.map((y) => DropdownMenuItem(value: y, child: Text(y == YesNo.yes ? 'Yes' : 'No'))).toList(),
                                        onChanged: (YesNo? v) => setState(() => _eatBeforeSleep = v),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: DropdownButtonFormField<YesNo>(
                                        isExpanded: true,
                                        initialValue: _isNightEater,
                                        decoration: _inputDecoration('Are you a night eater?'),
                                        items: YesNo.values.map((y) => DropdownMenuItem(value: y, child: Text(y == YesNo.yes ? 'Yes' : 'No'))).toList(),
                                        onChanged: (YesNo? v) => setState(() => _isNightEater = v),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(height: 8.h),
                                  Row(children: [
                                    Expanded(
                                      child: DropdownButtonFormField<SnackFeeling>(
                                        isExpanded: true,
                                        initialValue: _nightHungerOrSnack,
                                        decoration: _inputDecoration('Do you feel hungry at night or just snack?'),
                                        items: SnackFeeling.values.map((s) => DropdownMenuItem(value: s, child: Text(s == SnackFeeling.snack ? 'Snack' : 'Hungry'))).toList(),
                                        onChanged: (SnackFeeling? v) => setState(() => _nightHungerOrSnack = v),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        initialValue: _whenSnack,
                                        decoration: _inputDecoration('When do you have snack?'),
                                        items: ['After breakfast', 'After lunch', 'Between both'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                        onChanged: (String? v) => setState(() => _whenSnack = v),
                                      ),
                                    ),
                                  ]),
                                ])),

                                _sectionHeader('Sleep & Eating'),
                                _sectionCard(Column(children: [
                                  Row(children: [
                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                        controller: _avgSleepHoursController,
                                        decoration: _inputDecoration('Average sleep hours'),
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      flex: 4,
                                      child: DropdownButtonFormField<EatingSpeed>(
                                        isExpanded: true,
                                        initialValue: _eatingSpeed,
                                        decoration: _inputDecoration('Eating speed'),
                                        items: EatingSpeed.values.map((e) {
                                          final label = {
                                            EatingSpeed.fast: 'Fast',
                                            EatingSpeed.moderate: 'Moderate',
                                            EatingSpeed.slow: 'Slow',
                                          }[e]!;
                                          return DropdownMenuItem(value: e, child: Text(label));
                                        }).toList(),
                                        onChanged: (EatingSpeed? v) => setState(() => _eatingSpeed = v),
                                      ),
                                    ),
                                  ]),
                                ])),

                                _sectionHeader('Vegetables & Fruits'),
                                _sectionCard(Column(children: [
                                  TextFormField(controller: _vegFreqController, decoration: _inputDecoration('How often do you eat vegetables? (Cooked / Raw)')),
                                  SizedBox(height: 8.h),
                                  TextFormField(controller: _vegListController, decoration: _inputDecoration('Which vegetables does your kid eat?')),
                                  SizedBox(height: 8.h),
                                  TextFormField(controller: _fruitFreqController, decoration: _inputDecoration('How often do you eat fruits?')),
                                  SizedBox(height: 8.h),
                                  TextFormField(controller: _fruitListController, decoration: _inputDecoration('Which fruits does your kid eat?')),
                                  SizedBox(height: 8.h),
                                  DropdownButtonFormField<EatFruitDrink>(
                                    isExpanded: true,
                                    initialValue: _eatOrDrinkFruit,
                                    decoration: _inputDecoration('Do you eat the fruits or drink them?'),
                                    items: EatFruitDrink.values.map((v) {
                                      final label = v == EatFruitDrink.eat ? 'Eat' : 'Drink';
                                      return DropdownMenuItem(value: v, child: Text(label));
                                    }).toList(),
                                    onChanged: (EatFruitDrink? v) => setState(() => _eatOrDrinkFruit = v),
                                  ),
                                  SizedBox(height: 8.h),
                                  TextFormField(controller: _candyController, decoration: _inputDecoration('How often do they eat candy? What is it?')),
                                  SizedBox(height: 8.h),

                                  // <-- CHANGED BLOCK: horizontal compact checkboxes for cooking fat
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4.h),
                                      child: Wrap(
                                        spacing: 12.w,
                                        runSpacing: 6.h,
                                        children: [
                                          _smallCheckboxLabel(
                                            label: 'Oil',
                                            value: _usesOil,
                                            onChanged: (v) => setState(() => _usesOil = v),
                                          ),
                                          _smallCheckboxLabel(
                                            label: 'Butter',
                                            value: _usesButter,
                                            onChanged: (v) => setState(() => _usesButter = v),
                                          ),
                                          _smallCheckboxLabel(
                                            label: 'Margarine',
                                            value: _usesMargarine,
                                            onChanged: (v) => setState(() => _usesMargarine = v),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ])),

                                SizedBox(height: 16.h),
                                // Save / Cancel
                                Row(children: [
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
                                        backgroundColor: ColorsManager.accentMint,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                        elevation: 2,
                                      ),
                                      onPressed: _saveForm,
                                      child: Text('Save', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ]),

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

  // helper small horizontal checkbox + label widget
  Widget _smallCheckboxLabel({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(fontSize: 13.sp)),
        ],
      ),
    );
  }
}