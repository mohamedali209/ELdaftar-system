import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/eldaftarbutton_body.dart';
import 'package:flutter/material.dart';

class Desktopbody extends StatelessWidget {
  const Desktopbody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 1, child: Customdrawer()),
        Expanded(flex: 4, child: DaftarToday())
      ],
    );
  }
}


