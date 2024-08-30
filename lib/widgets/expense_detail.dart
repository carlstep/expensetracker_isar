import 'package:expensetracker_isar/widgets/expense_divider.dart';
import 'package:expensetracker_isar/widgets/expense_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../collections/expense.dart';
import '../util/config.dart';
import '../util/func.dart';

class ExpenseDetail extends StatefulWidget {
  const ExpenseDetail({super.key});

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();

  static const routeName = "/expense";
}

class _ExpenseDetailState extends State<ExpenseDetail> with Func {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ExpenseDetailArguments;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  DateFormat.EEEE().format(args.expense.date),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(
                  '${DateFormat.d().format(args.expense.date)} ${DateFormat.MMMM().format(args.expense.date)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    size: 30,
                    color: Colors.teal,
                  ),
                ),
              ),
              const ExpenseDivider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const TitleWidget(
                      title: 'Amount...',
                      clr: Colors.black,
                    ),
                    Text(
                      '\$ ${args.expense.amount}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          fontSize: 22),
                    ),
                  ],
                ),
              ),
              const ExpenseDivider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleWidget(
                      title: 'Category...',
                      clr: Colors.black,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/${categories[args.expense.category!.index]['icon']}',
                          width: 30,
                        ),
                        Text(
                          categories[args.expense.category!.index]['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const ExpenseDivider(),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: TitleWidget(
                  title: 'Receipts...',
                  clr: Colors.black,
                ),
              ),
              FutureBuilder(
                future: setConfigs(args),
                builder: (context, snapshot) {
                  Map<String, dynamic>? configs = snapshot.data;

                  if (snapshot.hasData) {
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, mainAxisSpacing: 4.0),
                        itemCount: configs!["count"],
                        itemBuilder: (BuildContext context, int index) {
                          return Image.asset(
                            configs["path"] +
                                "/${args.expense.receipts.elementAt(index).name}",
                            width: 50,
                          );
                        });
                  } else {
                    return const Text(
                      'No receipts to display...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    );
                  }
                },
              ),
              const ExpenseDivider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleWidget(
                      title: 'Payment Method...',
                      clr: Colors.black,
                    ),
                    Text(
                      args.expense.paymentMethod.toString(),
                    ),
                  ],
                ),
              ),
              const ExpenseDivider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleWidget(
                      title: 'Additional Details...',
                      clr: Colors.black,
                    ),
                    Text(
                      args.expense.description.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseDetailArguments {
  final Expense expense;

  ExpenseDetailArguments({required this.expense});
}
