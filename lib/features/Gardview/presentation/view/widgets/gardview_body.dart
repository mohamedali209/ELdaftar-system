import 'package:aldafttar/features/Gardview/presentation/view/widgets/elgard_expanded_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class Gardfawrybody extends StatelessWidget {
  const Gardfawrybody({super.key});
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 1, child: Customdrawer()),
        Expanded(flex: 4, child: Gard())
      ],
    );
  }
}

