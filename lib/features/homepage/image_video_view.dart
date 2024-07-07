import 'package:flutter/cupertino.dart';

import 'network_video_view.dart';

class ImageVideoView extends StatelessWidget {
  const ImageVideoView({
    super.key,
    required this.fileType,
    required this.fileUrl,
  });

  final String fileType;
  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    if (fileType == 'image') {
      return Image.network(fileUrl);
    } else {
      return NetworkVideoView(
        videoUrl: fileUrl,
      );
    }
  }
}