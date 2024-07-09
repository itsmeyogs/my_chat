import 'package:jiffy/jiffy.dart';

extension FormatDate on DateTime {
  String jm() => Jiffy.parseFromDateTime(this).jm;
}
