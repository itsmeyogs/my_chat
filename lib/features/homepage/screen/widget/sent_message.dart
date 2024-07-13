import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'message_contents.dart';
import '../../../../core/models/message.dart';

class SentMessage extends ConsumerWidget {
  final Message message;

  const SentMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 15),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Color(0XFF78909C),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: MessageContents(
                message: message,
                isSentMessage: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}