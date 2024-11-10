import 'package:aldafttar/features/Gardview/presentation/view/widgets/gardview_body.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_expanded_container.dart';
import 'package:flutter/material.dart';

class Tahlelbody extends StatelessWidget {
  const Tahlelbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Customdrawer(drawerKey: drawerKey2)),
         Expanded(flex: 4, child: Tahlelexpandedcontainer())
      ],
    );
  }
}