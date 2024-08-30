import 'package:expensetracker_isar/collections/receipt.dart';
import 'package:isar/isar.dart';

// this line is needed to generate the isar file
// run this code: dart run build_runner build

part 'expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;

  @Index()
  late double amount;

  @Index()
  late DateTime date;

  @Enumerated(EnumType.name)
  CategoryEnum? category;

  SubCategory? subCategory;

  final receipts = IsarLinks<Receipt>();

  @Index(composite: [CompositeIndex('amount')])
  String? paymentMethod;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String>? description;
}

enum CategoryEnum {
  bill,
  food,
  clothes,
  transport,
  entertainment,
  other,
}

@embedded
class SubCategory {
  String? name;
}
