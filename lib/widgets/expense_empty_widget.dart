import 'package:flutter/material.dart';

class ExpenseEmptyWidget extends StatelessWidget {
  const ExpenseEmptyWidget({
    super.key,
    required this.subtitle,
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();

    // EmptyWidget(
    //   image: null,
    //   packageImage: PackageImage.Image_1,
    //   title: 'Expense Tracker',
    //   subTitle: subtitle,
    //   titleTextStyle: const TextStyle(
    //     fontSize: 22,
    //     color: Color(0xff9da9c7),
    //     fontWeight: FontWeight.w500,
    //   ),
    //   subtitleTextStyle: const TextStyle(
    //     fontSize: 14,
    //     color: Color(0xffabb8d6),
    //   ),
    // );
  }
}
