import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_summary_item.dart';
import 'package:flutter/material.dart';

class TahlelsummaryItems extends StatelessWidget {
  const TahlelsummaryItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Tahlelsummaryitem(
          color: Color(0x785BC47B),
          date: 'من يوم 1 الي 30',
          title: 'الدفتر',
        ),
        Tahlelsummaryitem(
          color: Color(0xffD39335),
          date: 'من يوم 1 الي 30',
          title: 'الجرد',
        ),
        Tahlelsummaryitem(
          color: Color(0xffD33535),
          title: 'التحليلات',
        ),
      ],
    );
  }
}
