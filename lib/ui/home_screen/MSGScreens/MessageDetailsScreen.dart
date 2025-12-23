import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/model/msgsModels/BaseMessage.dart';
import '../../webView-attachmentopener/AttachmentViewerScreen.dart';

class MessageDetailsScreen extends StatelessWidget {
  static const routeName = '/message-details';

  final BaseMessage message;

  const MessageDetailsScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final originalAttachments = getOriginalAttachments(message);
    final replyAttachments = getReplyAttachments(message);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor:
            isDark ? Colors.black54 : Colors.white.withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white70 : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'message_details'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Sender Type
              Text(
                message.enDesc,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),

              SizedBox(height: 8.h),

              // ✅ Sender Name
              Text(
                message.empName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),

              SizedBox(height: 12.h),

              // ✅ Date
              Text(
                "Date: ${message.actualEditdate}",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),

              Divider(height: 30.h, thickness: 1),

              // ✅ Subject
              Text(
                message.noteSubject,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),

              SizedBox(height: 12.h),

              // ✅ Message Body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message.message, style: TextStyle(fontSize: 16.sp)),

                      SizedBox(height: 16.h),

                      // ✅ ✅ ORIGINAL ATTACHMENTS BUTTON
                      if (originalAttachments.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showAttachmentsPopup(
                                context,
                                originalAttachments,
                                title: "original_attachments".tr(),
                              );
                            },
                            icon: const Icon(Icons.attach_file),
                            label: Text("view_attachments".tr()),
                          ),
                        ),

                      SizedBox(height: 20.h),

                      // ✅ ✅ REPLY STATUS
                      if (message.replyStatus == 0)
                        Text(
                          "Waiting for your reply...",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      // ✅ ✅ SHOW REPLY
                      if (message.replyStatus == 1) ...[
                        Text(
                          "Reply:".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          message.noteBodyReply ?? '',
                          style: TextStyle(fontSize: 15.sp),
                        ),

                        SizedBox(height: 10.h),

                        if (replyAttachments.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showAttachmentsPopup(
                                  context,
                                  replyAttachments,
                                  title: "reply_attachments".tr(),
                                );
                              },
                              icon: const Icon(Icons.attach_file),
                              label: Text("reply_attachments".tr()),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ ✅ ORIGINAL ATTACHMENTS
  List<String> getOriginalAttachments(BaseMessage message) {
    final files = [
      message.noteFile,
      message.noteFile2,
      message.noteFile3,
      message.noteFile4,
      message.noteFile5,
    ];

    return files.whereType<String>().where((e) => e.isNotEmpty).toList();
  }

  // ✅ ✅ REPLY ATTACHMENTS
  List<String> getReplyAttachments(BaseMessage message) {
    final files = [
      message.noteFileReply,
      message.noteFile2Reply,
      message.noteFile3Reply,
      message.noteFile4Reply,
      message.noteFile5Reply,
    ];

    return files.whereType<String>().where((e) => e.isNotEmpty).toList();
  }

  void _showAttachmentsPopup(
    BuildContext context,
    List<String> files, {
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 12.h),

                ...files.map((file) {
                  final fileName = file.split('/').last;

                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(fileName, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttachmentViewerScreen(url: file),
                        ),
                      );
                      //_openAttachment(context, file);
                      print(file);
                    },
                  );
                }),

                SizedBox(height: 10.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("close".tr()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
