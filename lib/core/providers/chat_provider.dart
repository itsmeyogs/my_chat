import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/repository/chat_repository.dart';

final chatProvider = Provider(
  (ref) => ChatRepository(),
);
