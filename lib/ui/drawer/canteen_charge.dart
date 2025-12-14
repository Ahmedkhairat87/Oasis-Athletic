import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/reusable_components/app_background.dart';

class CanteenCharge extends StatefulWidget {
  static const routeName = '/canteenCharge';
  const CanteenCharge({super.key});

  @override
  State<CanteenCharge> createState() => _CanteenChargeState();
}

class _CanteenChargeState extends State<CanteenCharge> {
  bool isHistoryTab = false;
  String selectedStudent = 'Mazen'; // 🔑 dynamic student selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Canteen Charge'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                /// Students avatars (dynamic selection)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StudentAvatar(
                      name: 'Malek',
                      isSelected: selectedStudent == 'Malek',
                      onTap: () => setState(() => selectedStudent = 'Malek'),
                    ),
                    SizedBox(width: 30.w),
                    _StudentAvatar(
                      name: 'Mazen',
                      isSelected: selectedStudent == 'Mazen',
                      onTap: () => setState(() => selectedStudent = 'Mazen'),
                    ),
                  ],
                ),

                SizedBox(height: 25.h),

                /// Selected student name
                Text(
                  selectedStudent,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),

                SizedBox(height: 10.h),

                /// Current balance (placeholder, could be dynamic)
                Text(
                  'Current Balance : 1.00 L.E',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),

                SizedBox(height: 15.h),

                /// Note
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Please note: The payment will be processed and the amount '
                        'will appear on the student’s card within 4 working days.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                /// Tabs (Charge / Charging history)
                Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        title: 'Charge',
                        isActive: !isHistoryTab,
                        onTap: () => setState(() => isHistoryTab = false),
                      ),
                      _TabButton(
                        title: 'Charging history',
                        isActive: isHistoryTab,
                        onTap: () => setState(() => isHistoryTab = true),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                /// Tab content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isHistoryTab
                        ? const _ChargingHistory()
                        : const _ChargeOptions(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ======================
/// Charge tab content
/// ======================
class _ChargeOptions extends StatelessWidget {
  const _ChargeOptions();

  @override
  Widget build(BuildContext context) {
    final charges = ['500.0', '1000.0']; // 🔑 scalable list
    return ListView.separated(
      itemCount: charges.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) => _ChargeRow(amount: charges[index]),
    );
  }
}

/// ======================
/// Charging history tab content
/// ======================
class _ChargingHistory extends StatelessWidget {
  const _ChargingHistory();

  @override
  Widget build(BuildContext context) {
    final history = [
      {'date': '10/12/2025', 'amount': '500 L.E'},
      {'date': '02/12/2025', 'amount': '1000 L.E'},
    ];
    return ListView.separated(
      itemCount: history.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) => _HistoryRow(
        date: history[index]['date']!,
        amount: history[index]['amount']!,
      ),
    );
  }
}

/// ======================
/// Widgets
/// ======================

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(25.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
                : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentAvatar extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _StudentAvatar({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.blue,
                width: 2.w,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ]
                  : [],
            ),
            child: CircleAvatar(
              radius: 28.r,
              backgroundColor: isSelected
                  ? Colors.green.shade100
                  : Colors.blue.shade100,
              child: Icon(
                Icons.person,
                size: 30.sp,
                color: isSelected ? Colors.green : Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargeRow extends StatelessWidget {
  final String amount;

  const _ChargeRow({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Text('Amount', style: TextStyle(fontSize: 14.sp)),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 20.w),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              // 🔑 integrate backend payment API here
            },
            child: Text(
              'Pay Now',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String date;
  final String amount;

  const _HistoryRow({required this.date, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Text(date, style: TextStyle(fontSize: 14.sp)),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}