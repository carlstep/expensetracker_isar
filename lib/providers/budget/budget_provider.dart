import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:expensetracker_isar/collections/budget.dart';
import 'package:expensetracker_isar/util/func.dart';

part 'budget_provider.g.dart';

@riverpod
class ExpenseBudget extends _$ExpenseBudget with Func {
  @override
  Future<Budget?> build() =>
      getBudget(month: DateTime.now().month, year: DateTime.now().year)
          .then((value) => value);

  Future<void> create(double amount) async {
    Budget? budget = await createBudget(amount);

    state = AsyncValue.data(budget);
  }

  Future<void> editBudget(Budget bdgt) async {
    Budget? budget = await updateBudget(bdgt);

    state = AsyncValue.data(budget);
  }
}
