import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/model/msgsModels/BaseMessage.dart';

class MessagesWidget extends StatelessWidget {
  final BaseMessage msg;
  final String? studentFirstName;
  const MessagesWidget({super.key, required this.msg, this.studentFirstName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade900.withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black12.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          SizedBox(height: 4.h),
          _buildSenderName(isDark),
          SizedBox(height: 4.h),
          _buildMessageText(isDark),
          SizedBox(height: 6.h),
          _buildChildTag(isDark),
        ],
      ),
    );
  }

  // -------------------------------
  // 🔹 Header (Sender Type + Date)
  // -------------------------------
  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Text(
          msg.enDesc as String,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black,
          ),
        ),
        const Spacer(),
        Text(
          msg.actualEditdate as String,
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // -------------------------------
  // 🔹 Sender Name
  // -------------------------------
  Widget _buildSenderName(bool isDark) {
    return Text(
      msg.empName as String,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  // -------------------------------
  // 🔹 Message Text
  // -------------------------------
  Widget _buildMessageText(bool isDark) {
    return Text(
      msg.noteSubject as String,
      style: TextStyle(
        color: isDark ? Colors.white70 : Colors.grey,
      ),
    );
  }

  // -------------------------------
  // 🔹 Child Tag (Right Bubble)
  // -------------------------------
  Widget _buildChildTag(bool isDark) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.blue.shade700 : const Color(0xFF007AFF),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          studentFirstName ?? msg.studentNom,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}