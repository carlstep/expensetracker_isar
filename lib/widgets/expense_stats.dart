import 'package:expensetracker_isar/widgets/expense_general_stats.dart';
import 'package:expensetracker_isar/widgets/expense_log.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key, required this.view});

  final Map<int, bool> view;

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  int stats = 0;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.view[2]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Stats',
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ToggleSwitch(
              activeBgColor: const [Colors.teal],
              initialLabelIndex: stats,
              minWidth: MediaQuery.of(context).size.width * 0.4,
              labels: const ['General', 'Expense Log'],
              totalSwitches: 2,
              onToggle: (index) {
                setState(() {
                  stats = index!;
                });
              },
            ),
          ),
          (stats == 0) ? const GeneralStatistics() : const ExpenseLog()
        ],
      ),
    );
  }
}
