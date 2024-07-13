import 'package:flutter/material.dart';
import 'package:my_chat/core/constants/extensions.dart';

import '../../../../core/models/message.dart';

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
    return isSentMessage
        ? Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.35),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                Text(
                  message.message,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    children: [
                      Text(
                        message.timestamp.jm(),
                        style: const TextStyle(fontSize: 10, color: Color(0XFF005c4b)),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      message.seen
                          ? const Icon(
                              Icons.done_all,
                              color: Color(0XFF005c4b),
                              size: 16,
                            )
                          : const Icon(
                              Icons.done,
                              color: Color(0XFF005c4b),
                              size: 16,
                            )
                    ],
                  ),
                )
              ],
            ),
          )
        : Wrap(
            alignment: WrapAlignment.end,
            children: [
              Text(
                message.message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  message.timestamp.jm(),
                  style: const TextStyle(fontSize: 10, color: Color(0XFF005c4b)),
                ),
              )
            ],
          );
  }
}
