import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/eldafater.dart';
import 'package:aldafttar/features/daftarview/presentation/view/desktop_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class Eldafterbody extends StatelessWidget {
  const Eldafterbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Customdrawer(drawerKey: drawerKey)),
        const Expanded(flex: 4, child: Eldafater())
      ],
    );
  }
}
