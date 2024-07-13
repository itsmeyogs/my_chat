import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/user_repository.dart';

//provider untuk mengakses function yang ada di userRepository
final userProvider = Provider((ref){
  return UserRepository();
});