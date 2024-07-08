import 'package:flutter/material.dart';
import 'package:my_chat/core/constants/extensions.dart';
import 'package:my_chat/features/homepage/widget/image_video_view.dart';

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
      return isSentMessage ? Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width/1.35
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          children: [
            Text(
              message.message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8,),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
              children: [
                Text(message.timestamp.jm(), style: TextStyle(fontSize: 12),),
                SizedBox(width: 2,),
                message.seen?Icon(Icons.done_all, size: 20,):Icon(Icons.done, size: 20,)
              ],
              ),
            )
          ],
        ),
      ):Wrap(
        alignment: WrapAlignment.end,
        children: [
          Text(
            message.message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8,),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message.timestamp.jm(), style: TextStyle(fontSize: 12),),
          )

        ],);
    } else {
      final maxWidth = MediaQuery.of(context).size.width / 2;
      final maxHeight = MediaQuery.of(context).size.height / 3;
      return isSentMessage?Container(
        constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight:  maxHeight
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: ImageVideoView(
                fileUrl: message.message,
                fileType: message.messageType,
              ),
            ),
            Positioned(
                bottom: 0,
                right:0,
                child: Wrap(
                  children: [
                    Text(message.timestamp.jm(), style: TextStyle(fontSize: 12, color: Colors.white),),
                    SizedBox(width: 2,),
                    message.seen?Icon(Icons.done_all, size: 20,):Icon(Icons.done, size: 20,)
                  ],
                )
            )
          ],
        ),
      ):Container(
        constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight:  maxHeight
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: ImageVideoView(
                fileUrl: message.message,
                fileType: message.messageType,
              ),
            ),
            Positioned(
                bottom: 0,
                right:0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(message.timestamp.jm(), style: TextStyle(fontSize: 12, color: Colors.white),),
                )
            )
          ],
        ),
      );
    }
  }
}
