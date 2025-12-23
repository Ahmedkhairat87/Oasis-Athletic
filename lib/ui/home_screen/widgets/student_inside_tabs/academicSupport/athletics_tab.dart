import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/colors_Manager.dart';
import '../../../../../core/reusable_components/Notifiers/student_notifier.dart';
import '../../../../../core/services/stdProfile/stdAthleticServices/StdAthleticLinksService.dart';
import '../../../../webView-attachmentopener/openAttachment.dart';

class AthleticsReport {
  final String id;
  final DateTime publishedAt;
  DateTime? readAt;
  final String fileName;
  final String filePath;

  AthleticsReport({
    required this.id,
    required this.publishedAt,
    this.readAt,
    required this.fileName,
    required this.filePath,
  });

  bool get isRead => readAt != null;
}

class AthleticsTab extends StatefulWidget {
  const AthleticsTab({super.key});

  @override
  State<AthleticsTab> createState() => _AthleticsTabState();
}

class _AthleticsTabState extends State<AthleticsTab> {
  bool loading = false;
  List<AthleticsReport> _reports = [];
  final DateFormat _df = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    loadAthleticReports();
  }

  Future<void> loadAthleticReports() async {
    setState(() => loading = true);

    final stdId = studentNotifier.value.stdId.toString();

    final data = await StdAthleticLinksService.getAthleticReports(
      stdId: stdId,
    );

    if (!mounted) return;

    setState(() {
      loading = false;
      _reports = [];

      if (data?.stdAthleticsReports != null &&
          data!.stdAthleticsReports!.isNotEmpty) {
        _reports = data.stdAthleticsReports!.map((e) {
          return AthleticsReport(
            id: e.reportType ?? '',
            publishedAt: DateTime.parse(e.uploadDate!),
            readAt: e.parentRead == 1 && e.readedDate != null
                ? DateTime.parse(e.readedDate!)
                : null,
            fileName: e.filePath?.split('/').last ?? '',
            filePath: e.filePath ?? '',
          );
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final Color primaryBlue = isLight
        ? ColorsManager.primaryGradientStart
        : ColorsManager.primaryGradientStartDark;

    final reports = [..._reports]
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
          ? Center(
        child: Text(
          tr('no_reports_yet'),
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      )
          : ListView.separated(
        padding: EdgeInsets.only(bottom: 12.h),
        physics: const BouncingScrollPhysics(),
        itemCount: reports.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final r = reports[index];
          return _reportCard(context, r, index, primaryBlue);
        },
      ),
    );
  }

  Widget _reportCard(
      BuildContext context,
      AthleticsReport r,
      int index,
      Color primaryBlue,
      ) {
    final Color accentMint = ColorsManager.accentMint;
    final Color accentCoral = ColorsManager.accentCoral;
    final Color accentSky = ColorsManager.accentSky;

    final bool isRead = r.isRead;
    final Color statusColor = isRead ? accentMint : accentCoral;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: statusColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${tr('report')} ${r.id}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _onViewReport(context, r),
                child: Text(tr('view')),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            '${tr('published')}: ${_df.format(r.publishedAt)}',
            style: TextStyle(fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            r.readAt != null
                ? '${tr('read_on')}: ${_df.format(r.readAt!)}'
                : tr('not_read_yet'),
            style: TextStyle(fontSize: 12.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            isRead ? tr('read') : tr('unread'),
            style: TextStyle(
              color: Colors.white,
              backgroundColor: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  void _onViewReport(BuildContext context, AthleticsReport r) {
    setState(() {
      r.readAt ??= DateTime.now();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tr('report')} ${r.id}',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8.h),
              Text('${tr('published')}: ${_df.format(r.publishedAt)}'),
              SizedBox(height: 12.h),
              Text('${tr('file')}: ${r.fileName}'),
              SizedBox(height: 8.h),
              Text(tr('report_preview_placeholder')),
              SizedBox(height: 18.h),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  openAttachment(context, r.filePath);
                },
                icon: const Icon(Icons.file_download),
                label: Text(tr('download')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(tr('close')),
              ),
            ],
          ),
        );
      },
    );
  }
}