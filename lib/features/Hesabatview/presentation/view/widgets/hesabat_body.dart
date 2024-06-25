
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabatexpanded_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class Hesabatbody extends StatelessWidget {
  const Hesabatbody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
         Expanded(flex: 1, child: Customdrawer()),
        Expanded(flex: 4, child: Hesabatcontainer())
      ],
    );
  }
}
