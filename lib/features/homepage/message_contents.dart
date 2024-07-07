import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/features/homepage/image_video_view.dart';

import 'models/message.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    super.key,
    required this.message,
    this.isSentMessage = false,
  });

  final Message message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'text') {
      return Text(
        message.message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isSentMessage ? Colors.white : Colors.black,
        ),
      );
    } else {
      return ImageVideoView(
        fileUrl: message.message,
        fileType: message.messageType,
      );
    }
  }
}
