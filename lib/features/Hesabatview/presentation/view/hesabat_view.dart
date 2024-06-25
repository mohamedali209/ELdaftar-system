import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabat_scaffold.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:flutter/material.dart';

class Hesabatview extends StatelessWidget {
  const Hesabatview({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
        mobileLayout: (context) => const SizedBox(),
        tabletLayout: (context) => const SizedBox(),
        desktopLayout: (context) => const Hesabatscaffold());
  }
}
