import 'package:aldafttar/features/tahlelview/presentation/view/widgets/first_tahlel_list.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_summary_items.dart';
import 'package:flutter/material.dart';

class TahlelexpandedColumn extends StatelessWidget {
  const TahlelexpandedColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          TahlelsummaryItems(),
          SizedBox(
            height: 20,
          ),
          FirsttahlelList(),
        ]);
  }
}
