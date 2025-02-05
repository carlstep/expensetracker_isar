// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:expensetracker_isar/collections/budget.dart';
import 'package:expensetracker_isar/providers/budget/budget_provider.dart';
import 'package:expensetracker_isar/providers/expense/expense_provider.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  const HeaderWidget({
    super.key,
    required this.editBudget,
  });

  final bool editBudget;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  double percent = 0.0;
  double totalValue = 0.0;
  double budgetValue = 0.0;

  final TextEditingController budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Budget?> budget = ref.watch(expenseBudgetProvider);
    final AsyncValue<double?> total = ref.watch(expenseMainProvider);

    totalValue = switch (total) {
      AsyncData(:final value) => value!,
      AsyncError() => 0,
      _ => 0
    };

    budgetValue = switch (budget) {
      AsyncData(:final value) => value?.amount ?? 0,
      AsyncError() => 0,
      _ => 0
    };

    Future.delayed(Duration.zero, () {
      budgetController.text = budgetValue.toString();
    });

    percent = totalValue / budgetValue;

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              DateFormat.MMMM().format(
                DateTime.now(),
              ),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            subtitle: Text(
              DateTime.now().year.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.teal),
            ),
          ),
          SizedBox(
            child: CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 30,
              progressColor: Colors.teal,
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              percent: 0.1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: RichText(
              text: TextSpan(
                text: totalValue.toString(),
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' / ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: budgetValue.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.editBudget,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Budget',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          content: TextField(
                            controller: budgetController,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              hintText: 'Enter Budget Amount',
                              suffix: Text(
                                '\$',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                              onPressed: () {
                                createNewBudget(budget);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      });
                },
                style: OutlinedButton.styleFrom(foregroundColor: Colors.teal),
                child: Text(
                  (budget.value == null) ? 'Create Budget' : 'Update Budget',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  createNewBudget(AsyncValue<Budget?> budget) {
    try {
      if (budget.value == null) {
        ref
            .read(expenseBudgetProvider.notifier)
            .create(double.parse(budgetController.text));
      } else {
        Budget? bdgt = switch (budget) {
          AsyncData(:final value) => value!,
          AsyncError() => null,
          _ => null
        };

        if (bdgt != null) {
          bdgt.amount = double.parse(budgetController.text);
          ref.read(expenseBudgetProvider.notifier).editBudget(bdgt);
        }
      }
    } on IsarError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
    Navigator.pop(context);
  }
}
