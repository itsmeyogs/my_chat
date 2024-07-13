import 'package:flutter/material.dart';
import 'package:my_chat/core/constants/extensions.dart';

import '../../../../core/models/message.dart';

//widget ini digunakan untuk mengatur tampilan isi chat dan membedakan yang mana dari orang lain atau dari diri sendiri
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
    //mengecek apakah ini merupakan message yang dikirim
    return isSentMessage
        // jika true
        ? Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.35),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                //ditampilkan isi pesan
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
                      //ditampilkan waktu kirim pesan
                      Text(
                        message.timestamp.jm(),
                        style: const TextStyle(fontSize: 10, color: Color(0XFF005c4b)),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      //ditampilkan icon apakah pesan sudah dilihat atau belum
                      message.seen
                      //jika sudah maka akan ditampilkan icon centang 2
                          ? const Icon(
                              Icons.done_all,
                              color: Color(0XFF005c4b),
                              size: 16,
                            )
                      //dan jika belum maka akan ditampilkan icon centang 1
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
        //jika dari orang lain
        : Wrap(
            alignment: WrapAlignment.end,
            children: [
              Text(
                //maka ditampilkan isi pesan
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
                  //dan ditampilkan waktu pesan dikirim
                  message.timestamp.jm(),
                  style: const TextStyle(fontSize: 10, color: Color(0XFF005c4b)),
                ),
              )
            ],
          );
  }
}
