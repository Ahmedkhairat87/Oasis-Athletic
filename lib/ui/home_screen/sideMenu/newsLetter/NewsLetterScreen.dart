import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/colors_Manager.dart';
import '../../../../../core/reusable_components/profile_tab_section_title.dart';
import '../../../../core/model/sideMenu/NewsLetterItem.dart';
import '../../../../core/services/sideMenu/StdNewsLetterService.dart';
import '../../../webView-attachmentopener/openAttachment.dart';

class NewsLetterScreen extends StatefulWidget {
  const NewsLetterScreen({super.key});
  static const routeName = '/Newsletter';

  @override
  State<NewsLetterScreen> createState() => _NewsLetterScreenState();
}

class _NewsLetterScreenState extends State<NewsLetterScreen> {
  bool loading = true;
  List<NewsLetterItem> _items = [];

  @override
  void initState() {
    super.initState();
    loadNewsLetter();
  }

  Future<void> loadNewsLetter() async {
    setState(() => loading = true);

    final data = await StdNewsLetterService.getNewsLetter();

    if (!mounted) return;

    if (data == null) {
      setState(() {
        loading = false;
        _items = [];
      });
      return;
    }

    setState(() {
      loading = false;
      _items = [];

      if (data?.data != null && data!.data!.isNotEmpty) {
        _items = data.data!.map((e) {
          return NewsLetterItem(
            date: e.newsDate ?? '',
            url: e.fullPathE ?? '',
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

    return Container(
      // ✅ FIX 1: paint background
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ FIX 2: DO NOT use SectionTitle here
            Text(
              'Newsletter',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: 12.h),

            if (loading)
              const Center(child: CircularProgressIndicator())

            // ✅ FIX 3a: explicit empty state
            else if (_items.isEmpty)
              _emptyState(context)

            else
              ..._items.map(
                    (item) => Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _newsletterCard(context, item, primaryBlue),
                ),
              ),

            SizedBox(height: 18.h),

            Text(
              'Tap a newsletter card to open the full issue.',
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newsletterCard(
      BuildContext context,
      NewsLetterItem item,
      Color primaryBlue,
      ) {
    final Color accentSky = ColorsManager.accentSky;
    final Color accentMint = ColorsManager.accentMint;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => openAttachment(context, item.url),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryBlue.withOpacity(0.95),
                accentSky.withOpacity(0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.newspaper,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Tap to open newsletter',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.9),
                size: 28.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Column(
        children: [
          Icon(
            Icons.newspaper_outlined,
            size: 48.sp,
            color: Theme.of(context)
                .iconTheme
                .color
                ?.withOpacity(0.6),
          ),
          SizedBox(height: 12.h),
          Text(
            'No newsletters available',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}