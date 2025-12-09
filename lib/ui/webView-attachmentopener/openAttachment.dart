import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'AttachmentViewerScreen.dart';

void openAttachment(BuildContext context, String url) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AttachmentViewerScreen(url: url),
    ),
  );
}