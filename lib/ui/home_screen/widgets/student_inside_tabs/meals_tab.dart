// lib/ui/home_screen/widgets/student_inside_tabs/meals_tab.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/colors_Manager.dart';

enum MealStatus { allPlate, mostPlate, tasted, none }

class DayMeals {
  final DateTime date;
  final MealStatus breakfast;
  final MealStatus lunch;
  final MealStatus dinner;

  DayMeals({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });
}

class MealsTab extends StatefulWidget {
  const MealsTab({super.key});

  @override
  State<MealsTab> createState() => _MealsTabState();
}

class _MealsTabState extends State<MealsTab> with TickerProviderStateMixin {
  late final TabController _monthsController;
  final int _monthsRange = 6;
  late final List<DateTime> _months;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final Map<String, DayMeals> _mockData = {};

  @override
  void initState() {
    super.initState();

    _months = List.generate(_monthsRange * 2 + 1, (i) {
      final offset = i - _monthsRange;
      final d = DateTime(DateTime.now().year, DateTime.now().month + offset);
      return DateTime(d.year, d.month);
    });

    _selectedMonth = _months[_monthsRange];

    _monthsController = TabController(
      length: _months.length,
      vsync: this,
      initialIndex: _monthsRange,
    );

    _generateMockData();
  }

  @override
  void dispose() {
    _monthsController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    for (final month in _months) {
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      for (int d = 1; d <= daysInMonth; d++) {
        final date = DateTime(month.year, month.month, d);
        final key = _keyFor(date);
        final seed = date.day + month.month;

        MealStatus pick(int offset) {
          final v = (seed + offset) % 4;
          return MealStatus.values[v];
        }

        _mockData[key] = DayMeals(
          date: date,
          breakfast: pick(0),
          lunch: pick(1),
          dinner: pick(2),
        );
      }
    }
  }

  String _keyFor(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Color _statusColor(MealStatus s) {
    switch (s) {
      case MealStatus.allPlate:
        return ColorsManager.accentMint;
      case MealStatus.mostPlate:
        return ColorsManager.accentSky;
      case MealStatus.tasted:
        return ColorsManager.accentSun;
      case MealStatus.none:
        return ColorsManager.accentCoral;
    }
  }

  String _statusLabel(MealStatus s) {
    switch (s) {
      case MealStatus.allPlate:
        return tr('meal_all_plate');
      case MealStatus.mostPlate:
        return tr('meal_most_plate');
      case MealStatus.tasted:
        return tr('meal_tasted');
      case MealStatus.none:
        return tr('meal_none');
    }
  }

  String _statusEmoji(MealStatus s) {
    switch (s) {
      case MealStatus.allPlate:
        return '🍽️';
      case MealStatus.mostPlate:
        return '🍛';
      case MealStatus.tasted:
        return '👅';
      case MealStatus.none:
        return '🚫';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color primaryBlue = isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;
    final Color accentSun = ColorsManager.accentSun;
    final Color accentSky = ColorsManager.accentSky;
    final Color accentPurple = ColorsManager.accentPurple;

    return SafeArea(
      top: false,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          final double t = value.clamp(0.0, 1.0);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 10),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(color: Colors.transparent),
                    ),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr('meal_guide_title'),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _guideRow(MealStatus.allPlate,
                              tr('meal_guide_all_plate')),
                          SizedBox(height: 6.h),
                          _guideRow(MealStatus.mostPlate,
                              tr('meal_guide_most_plate')),
                          SizedBox(height: 6.h),
                          _guideRow(MealStatus.tasted,
                              tr('meal_guide_tasted')),
                          SizedBox(height: 6.h),
                          _guideRow(MealStatus.none,
                              tr('meal_guide_none')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _buildCalendarForMonth(
                  context,
                  _selectedMonth,
                  primaryBlue,
                  accentSun,
                  accentSky,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideRow(MealStatus s, String text) {
    final color = _statusColor(s);
    return Row(
      children: [
        Text(_statusEmoji(s), style: TextStyle(fontSize: 18.sp)),
        SizedBox(width: 10.w),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildCalendarForMonth(
      BuildContext context,
      DateTime month,
      Color primaryBlue,
      Color accentSun,
      Color accentSky,
      ) {
    final labels = [
      tr('weekday_sun'),
      tr('weekday_mon'),
      tr('weekday_tue'),
      tr('weekday_wed'),
      tr('weekday_thu'),
      tr('weekday_fri'),
      tr('weekday_sat'),
    ];

    return Column(
      children: [
        Row(
          children: List.generate(7, (i) {
            return Expanded(
              child: Center(child: Text(labels[i])),
            );
          }),
        ),
      ],
    );
  }

  void _onDayTap(DateTime day) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _mealStatusRow(tr('meal_breakfast'), MealStatus.tasted),
              SizedBox(height: 10.h),
              _mealStatusRow(tr('meal_lunch'), MealStatus.tasted),
              SizedBox(height: 10.h),
              _mealStatusRow(tr('meal_dinner'), MealStatus.tasted),
              SizedBox(height: 18.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(tr('close')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mealStatusRow(String label, MealStatus s) {
    final color = _statusColor(s);
    return Row(
      children: [
        Text(label),
        const Spacer(),
        Text('${_statusEmoji(s)}  ${_statusLabel(s)}',
            style: TextStyle(color: color)),
      ],
    );
  }
}