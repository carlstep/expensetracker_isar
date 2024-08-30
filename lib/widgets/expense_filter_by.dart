import 'package:expensetracker_isar/util/config.dart';
import 'package:expensetracker_isar/widgets/expense_filter.dart';
import 'package:flutter/material.dart';

class FilterBy extends StatefulWidget {
  const FilterBy({super.key});

  @override
  State<FilterBy> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FilterBy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter By...',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.teal,
                        size: 30,
                      ),
                    )
                  ],
                ),
                Column(
                  children: buildWidget(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildWidget() {
    List<Widget> options = [];

    for (int i = 0; i < filterOptions.length; i++) {
      options.add(Card(
        child: ListTile(
          title: Text(filterOptions[i]),
          onTap: () {
            Navigator.pushNamed(
              context,
              Filter.routeName,
              arguments: FilterArguments(fb: Filterby.values[i]),
            );
          },
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.teal,
          ),
        ),
      ));
    }
    return options;
  }
}
