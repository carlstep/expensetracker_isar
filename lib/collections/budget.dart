import 'package:isar/isar.dart';

// this line is needed to generate the isar file
// run this code: dart run build_runner build

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int month;

  late int year;

  double? amount;
}
