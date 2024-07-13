import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/repository/chat_repository.dart';

//provider untuk mengakses function yang ada di chatRepository
final chatProvider = Provider(
  (ref) => ChatRepository(),
);
