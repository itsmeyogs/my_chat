import 'package:jiffy/jiffy.dart';

//menambahkan extensi FormatDate untuk DateTime dengan menggunakan jiffy

extension FormatDate on DateTime {
  String jm() => Jiffy.parseFromDateTime(this).jm;
}
