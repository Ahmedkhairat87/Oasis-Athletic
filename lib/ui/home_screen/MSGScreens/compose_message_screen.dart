import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/reusable_components/app_background.dart';


class ComposeMessageScreen extends StatefulWidget {
  static const routeName = '/compose-message';
  const ComposeMessageScreen({super.key});

  @override
  State<ComposeMessageScreen> createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  String? selectedChild;
  String? selectedReceiver;
  bool isSending = false;

  final List<String> children = ["Student 1", "Student 2"];
  final List<String> receivers = ["Administration", "Teachers"];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context, isDark),
      body: AppBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChildSelector(isDark),
                SizedBox(height: 16.h),
                _buildReceiverSelector(isDark),
                SizedBox(height: 16.h),
                _buildMessageField(isDark),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(isDark),
    );
  }

  // -------------------------------
  // 🔹 AppBar
  // -------------------------------
  AppBar _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor:
      (isDark ? Colors.black54 : Colors.white.withOpacity(0.2)),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'New Message',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white70 : Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 Child Selector
  // -------------------------------
  Widget _buildChildSelector(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white10.withOpacity(0.3)
            : Colors.grey.shade200.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          hint: Text(
            "Select Child",
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: selectedChild,
          isExpanded: true,
          items: children.map((child) {
            return DropdownMenuItem<String>(
              value: child,
              child: Text(
                child,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => selectedChild = value),
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 Receiver Selector (Administration / Teachers)
  // -------------------------------
  Widget _buildReceiverSelector(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white10.withOpacity(0.3)
            : Colors.grey.shade200.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          hint: Text(
            "Send To",
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: selectedReceiver,
          isExpanded: true,
          items: receivers.map((receiver) {
            return DropdownMenuItem<String>(
              value: receiver,
              child: Text(
                receiver,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => selectedReceiver = value),
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 Message Field
  // -------------------------------
  Widget _buildMessageField(bool isDark) {
    return TextField(
      controller: _messageController,
      maxLines: 10,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
        hintText: 'Type your message...',
        hintStyle:
        TextStyle(color: isDark ? Colors.white70 : Colors.black45),
        filled: true,
        fillColor: isDark
            ? Colors.white10.withOpacity(0.3)
            : Colors.grey.shade200.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 Bottom Bar (Attachment + Send)
  // -------------------------------
  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black54.withOpacity(0.5)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: const Offset(0, -2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.attach_file_rounded,
                  size: 28, color: isDark ? Colors.white70 : Colors.black54),
              onPressed: _pickAttachment,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isSending ? null : _sendMessage,
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                label: Text(
                  isSending ? "Sending..." : "Send Message",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // 🔹 Actions
  // -------------------------------
  void _pickAttachment() {
    // TODO: integrate file picker (images, pdfs, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attachment picker not implemented yet")),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty ||
        selectedChild == null ||
        selectedReceiver == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all fields")),
      );
      return;
    }

    setState(() => isSending = true);

    await Future.delayed(const Duration(seconds: 2)); // simulate sending

    setState(() => isSending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Message sent to $selectedReceiver regarding $selectedChild",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}