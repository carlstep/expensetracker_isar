import 'package:expensetracker_isar/collections/expense.dart';
import 'package:isar/isar.dart';

// this line is needed to generate the isar file
// run this code: dart run build_runner build

part 'receipt.g.dart';

@collection
class Receipt {
  Id id = Isar.autoIncrement;

  late String name;

  @Backlink(to: 'receipts')
  final expense = IsarLink<Expense>();
}
