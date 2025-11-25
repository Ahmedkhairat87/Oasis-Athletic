import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/colors_Manager.dart';
import '../../core/reusable_components/app_background.dart';

/// Messages screen: choose child -> recipient type -> recipient -> subject -> message -> send
class sendMessagesScreen extends StatefulWidget {
  static const routeName = '/sendMessagesScreen';
  const sendMessagesScreen({super.key});

  @override
  State<sendMessagesScreen> createState() => _sendMessagesScreenState();
}

class _sendMessagesScreenState extends State<sendMessagesScreen> {
  // === sample data (replace with real data from your APIs) ===
  final String sampleChildImage =
      '/mnt/data/WhatsApp Image 2025-11-24 at 09.18.47.jpeg';

  final List<_Child> children = [
    _Child(
      name: 'Malek',
      avatarPath: '/mnt/data/WhatsApp Image 2025-11-24 at 09.18.47.jpeg',
    ),
    _Child(name: 'Mazen', avatarPath: ''),
  ];

  final List<String> teachers = ['Teacher 1', 'Teacher 2', 'Teacher 3'];
  final List<String> coaches = ['Coach 1', 'Coach 2'];
  final List<String> admins = ['Admin 1', 'Admin 2'];

  // === UI state ===
  int selectedChildIndex = 0;
  RecipientType selectedRecipientType = RecipientType.teacher;
  String? selectedRecipient; // teacher/coach/admin
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // default recipient from teachers list
    selectedRecipient = teachers.isNotEmpty ? teachers.first : null;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  List<String> get currentRecipientList {
    switch (selectedRecipientType) {
      case RecipientType.teacher:
        return teachers;
      case RecipientType.coach:
        return coaches;
      case RecipientType.admin:
        return admins;
    }
  }

  void _onSend() {
    // Replace this with your actual send logic / API call
    final child = children[selectedChildIndex].name;
    final to = selectedRecipient ?? '(none)';
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message body cannot be empty'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // demo toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending message to $to for $child'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // clear inputs on success (optional)
    // _subjectController.clear();
    // _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final Color primaryBlue =
    isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;
    final Color accentMint = ColorsManager.accentMint;
    final Color accentSky = ColorsManager.accentSky;

    return Scaffold(
      // App background component used in your app — keeps theme consistent
      body: AppBackground(
        useAppBarBlur: false,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                // ---- top app-style row with back button ----
                SizedBox(height: 6.h),
                Row(
                  children: [
                    SizedBox(
                      width: 44.w,
                      height: 44.h,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.arrow_back, size: 22.r, color: theme.iconTheme.color),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'New Message',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w), // keep spacing similar to other screens
                  ],
                ),

                // ---------- top row: pick child ----------
                SizedBox(height: 8.h),
                _sectionTitle('Select child'),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 120.h,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double viewportWidth = constraints.maxWidth;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: viewportWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: children.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final c = entry.value;
                              final bool selected = idx == selectedChildIndex;

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: GestureDetector(
                                  onTap: () => setState(() => selectedChildIndex = idx),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    width: 120.w,
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: selected ? primaryBlue.withOpacity(0.12) : theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: selected ? primaryBlue : Colors.transparent,
                                        width: selected ? 1.4 : 0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildAvatar(
                                          c.avatarPath,
                                          radius: 32.r,
                                          borderColor: selected ? primaryBlue : Colors.transparent,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          c.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 18.h),

                // ---------- recipient type row: teacher / coach / admin ----------
                _sectionTitle('Send to'),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  RecipientType.values.map((type) {
                    final bool isSel = type == selectedRecipientType;
                    final label = _labelForType(type);
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isSel
                                ? primaryBlue
                                : theme.colorScheme.surface,
                            foregroundColor:
                            isSel
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: isSel ? 6 : 0,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedRecipientType = type;
                              final list = currentRecipientList;
                              selectedRecipient =
                              list.isNotEmpty ? list.first : null;
                            });
                          },
                          child: Text(label, textAlign: TextAlign.center),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 14.h),

                // ---------- recipient selector (depends on selected type) ----------
                _sectionTitle('Choose recipient'),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 110.h,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double viewportWidth = constraints.maxWidth;
                      final list = currentRecipientList; // teachers / coaches / admins
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: viewportWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // 🔑 change to start, center, end, spaceBetween, etc.
                            children: list.map((name) {
                              final bool isSel = name == selectedRecipient;
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: GestureDetector(
                                  onTap: () => setState(() => selectedRecipient = name),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 140.w,
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: isSel ? primaryBlue.withOpacity(0.12) : theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: isSel ? primaryBlue : Colors.transparent,
                                        width: isSel ? 1.4 : 0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 28.r,
                                          backgroundColor: theme.colorScheme.surface,
                                          child: Text(
                                            _initialsOf(name),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryBlue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 12.h),

                // ---------- Subject ----------
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      'Subject',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    hintText: 'Subject (optional)',
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // ---------- Message (expandable) ----------
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      'Message',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Write your message here...',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // ---------- Send button ----------
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _onSend,
                        icon: const Icon(Icons.send),
                        label: const Text('Send'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 6.w),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildAvatar(
      String path, {
        required double radius,
        Color borderColor = Colors.transparent,
      }) {
    final Widget avatarChild;
    if (path.isNotEmpty && File(path).existsSync()) {
      avatarChild = ClipOval(
        child: Image.file(
          File(path),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatarChild = CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: radius),
      );
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderColor == Colors.transparent ? 0 : 2,
        ),
      ),
      child: avatarChild,
    );
  }

  String _initialsOf(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return '${parts.first.characters.first.toUpperCase()}${parts[1].characters.first.toUpperCase()}';
  }

  String _labelForType(RecipientType t) {
    switch (t) {
      case RecipientType.teacher:
        return 'Teacher';
      case RecipientType.coach:
        return 'Coach';
      case RecipientType.admin:
        return 'Administration';
    }
  }
}

enum RecipientType { teacher, coach, admin }

class _Child {
  final String name;
  final String avatarPath;
  _Child({required this.name, required this.avatarPath});
}