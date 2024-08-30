// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expensetracker_isar/util/func.dart';
import 'package:expensetracker_isar/widgets/expense_empty_widget.dart';
import 'package:expensetracker_isar/widgets/expense_list_with_filter.dart';
import 'package:expensetracker_isar/widgets/expense_list_without_filter.dart';

class ExpenseListWidget extends ConsumerStatefulWidget {
  const ExpenseListWidget({
    super.key,
    required this.filter,
    required this.all,
  });

  final bool filter;
  final bool all;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends ConsumerState<ExpenseListWidget>
    with Func {
  @override
  Widget build(BuildContext context) {
    return (widget.filter)
        ? ExpenseListWithFilter(
            ref: ref,
            widget: widget,
          )
        : FutureBuilder(
            future: (widget.all) ? getAllExpenses() : getTodaysExpenses(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const ExpenseEmptyWidget(
                      subtitle: 'No Expenses Available');
                } else {
                  return ExpenseListWithoutFilter(
                    ref: ref,
                    snapshot: snapshot,
                  );
                }
              } else {
                return const ExpenseEmptyWidget(
                    subtitle: 'No Expenses Available');
              }
            });
  }
}
