import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/MSGScreens/sendMessagesScreen.dart';

import '../../core/colors_Manager.dart';
import '../../core/reusable_components/app_background.dart';

/// Route: MessagesScreen.routeName
class MessagesScreen extends StatefulWidget {
  static const routeName = '/messagesScreen';
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String selectedFilter = "All";
  String selectedTab = "Inbox";

  final List<Map<String, dynamic>> messages = [
    {
      "senderType": "Teacher",
      "senderName": "Ms. Sarah",
      "message": "Reminder: parent-teacher meeting tomorrow at 3pm.",
      "date": "18-10-2025",
      "child": "Malek",
    },
    {
      "senderType": "Coach",
      "senderName": "Coach Ahmed",
      "message": "Training tomorrow at 5pm — bring shin guards.",
      "date": "17-10-2025",
      "child": "Mazen",
    },
    {
      "senderType": "Administration",
      "senderName": "Admin Office",
      "message": "School closed next Monday for maintenance.",
      "date": "12-10-2025",
      "child": "Malek",
    },
  ];

  // small sample children list for filters
  final List<String> children = ['All', 'Malek', 'Mazen'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // colors from your ColorsManager
    final Color primaryBlue =
    isDark ? ColorsManager.primaryGradientStartDark : ColorsManager.primaryGradientStart;
    final surface = theme.colorScheme.surface.withOpacity(0.78);

    return Scaffold(
      // keep the body full-bleed and use your AppBackground
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((kToolbarHeight + MediaQuery.of(context).padding.top).h),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: surface,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      // back button (same look as your app)
                      SizedBox(
                        width: 44.w,
                        height: 44.h,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.maybePop(context),
                          icon: Icon(Icons.arrow_back, size: 22.r, color: theme.iconTheme.color),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // title
                      Expanded(
                        child: Text(
                          'Messages',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, sendMessagesScreen.routeName);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Image.asset(
                            'assets/images/compose.png',
                            width: 30.w,
                            height: 30.h,
                            errorBuilder: (_, __, ___) => Icon(Icons.create_rounded, size: 22.r),
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

      body: AppBackground(
        useAppBarBlur: false,
        child: SafeArea(
          top: false, // AppBar already handled SafeArea
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              children: [
                // Top tabs (Inbox / Sent)
                _TopTabs(
                  selectedTab: selectedTab,
                  onTabSelected: (t) => setState(() => selectedTab = t),
                ),

                SizedBox(height: 12.h),

                // Filter chips row (children)
                _FilterChips(
                  children: children,
                  selected: selectedFilter,
                  onSelected: (s) => setState(() => selectedFilter = s),
                ),

                SizedBox(height: 14.h),

                // Messages list
                Expanded(
                  child: _MessagesList(
                    messages: messages,
                    filter: selectedFilter,
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

/// Top tabs widget (Inbox / Sent)
class _TopTabs extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;
  const _TopTabs({required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.white10.withOpacity(0.2) : Colors.grey.shade200.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          _TopTab(title: 'Inbox', isSelected: selectedTab == 'Inbox', onTap: () => onTabSelected('Inbox')),
          _TopTab(title: 'Sent', isSelected: selectedTab == 'Sent', onTap: () => onTabSelected('Sent')),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _TopTab({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? Colors.blueAccent.withOpacity(0.28) : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: isSelected && !isDark ? [BoxShadow(color: Colors.black12, blurRadius: 2)] : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white60 : Colors.grey),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Filter chips row (children selector)
class _FilterChips extends StatelessWidget {
  final List<String> children;
  final String selected;
  final ValueChanged<String> onSelected;

  const _FilterChips({
    required this.children,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color selectedColor = ColorsManager.primaryGradientStart;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children.map((c) {
        final bool isSel = c == selected;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: GestureDetector(
            onTap: () => onSelected(c),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSel ? selectedColor : (isDark ? Colors.white10.withOpacity(0.3) : Colors.grey.shade200.withOpacity(0.8)),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                c,
                style: TextStyle(
                  color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Messages list widget (reusable)
class _MessagesList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final String filter; // child name or "All"
  const _MessagesList({required this.messages, required this.filter});

  @override
  Widget build(BuildContext context) {
    final filtered = filter == 'All' ? messages : messages.where((m) => m['child'] == filter).toList();

    if (filtered.isEmpty) {
      return Center(child: Text('No messages'));
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      padding: EdgeInsets.only(bottom: 20.h, top: 6.h),
      itemBuilder: (context, index) {
        final msg = filtered[index];
        return MessageTile(
          senderType: msg['senderType'] as String? ?? '',
          senderName: msg['senderName'] as String? ?? '',
          message: msg['message'] as String? ?? '',
          date: msg['date'] as String? ?? '',
          childName: msg['child'] as String? ?? '',
        );
      },
    );
  }
}

/// Reusable single message tile
class MessageTile extends StatelessWidget {
  final String senderType;
  final String senderName;
  final String message;
  final String date;
  final String childName;

  const MessageTile({
    required this.senderType,
    required this.senderName,
    required this.message,
    required this.date,
    required this.childName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final Color primaryBlue = isLight ? ColorsManager.primaryGradientStart : ColorsManager.primaryGradientStartDark;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 1.5,
      child: InkWell(
        onTap: () {
          // implement message open / details navigation if you have one
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open message from $senderName')));
        },
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: theme.colorScheme.surface,
                child: Text(
                  _initialsOf(senderName),
                  style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // first line: sender name + child
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            senderName,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(date, style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12.sp)),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      childName,
                      style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initialsOf(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return '${parts.first.characters.first.toUpperCase()}${parts[1].characters.first.toUpperCase()}';
  }
}