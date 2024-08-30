import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/expense/expense_provider.dart';
import 'expense_list.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              focusColor: Colors.white,
              hintText: "Search expense...",
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: ((value) {
            ref
                .read(expenseFilterProvider.notifier)
                .filterByFullTextSearch(searchController.text);
          }),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10.0),
        child: ExpenseListWidget(filter: true, all: true),
      ),
    );
  }
}
