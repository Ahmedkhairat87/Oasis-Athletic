// lib/core/reusable_components/emergency_contact_field.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/core/reusable_components/profile_tab_labeled_text_field.dart';

class EmergencyContactField extends StatelessWidget {
  const EmergencyContactField({
    super.key,
    required this.index,
    required this.nameController,
    required this.mobileController,
    required this.relationController,
  });

  final int index;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController relationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Emergency ${index + 1}'.tr(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(child: LabeledTextField(controller: nameController, hint: 'Name'.tr())),
            SizedBox(width: 8.w),
            Expanded(child: LabeledTextField(controller: mobileController, hint: 'Mobile'.tr(), keyboardType: TextInputType.phone)),
          ],
        ),
        SizedBox(height: 6.h),
        LabeledTextField(controller: relationController, hint: 'Relation'.tr()),
        SizedBox(height: 10.h),
      ],
    );
  }
}