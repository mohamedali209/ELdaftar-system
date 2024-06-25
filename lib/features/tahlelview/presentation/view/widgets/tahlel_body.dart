import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlelexpanded_column.dart';
import 'package:flutter/material.dart';

class Tahlelbody extends StatelessWidget {
  const Tahlelbody({super.key});
  @override
  Widget build(BuildContext context) {
    return  const Row(
      children: [
        Expanded(flex: 1, child: Customdrawer()),
        Expanded(flex: 4, child: TahlelexpandedColumn())
      ],
    );
  }
}
