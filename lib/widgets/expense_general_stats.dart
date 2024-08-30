import 'package:expensetracker_isar/widgets/expense_category_statistics.dart';
import 'package:expensetracker_isar/widgets/expense_header.dart';
import 'package:flutter/material.dart';

class GeneralStatistics extends StatelessWidget {
  const GeneralStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HeaderWidget(
          editBudget: false,
        ),
        ExpenseCategoryStatistics(),
      ],
    );
  }
}
