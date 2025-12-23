import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageDropdown extends StatelessWidget {
  final bool isDarkMode;

  const LanguageDropdown({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentLocale,
        dropdownColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
        items: const [
          DropdownMenuItem(value: 'en', child: Text('English')),
          DropdownMenuItem(value: 'ar', child: Text('العربية')),
          DropdownMenuItem(value: 'fr', child: Text('Français')),
        ],
        onChanged: (value) async {
          if (value == null) return;
          await context.setLocale(Locale(value));
        },
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
        ),
      ),
    );
  }
}