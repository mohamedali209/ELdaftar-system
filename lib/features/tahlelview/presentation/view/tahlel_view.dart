import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_scaffold.dart';
import 'package:flutter/material.dart';

class Tahlelview extends StatelessWidget {
  const Tahlelview({super.key});
  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
        mobileLayout: (context) => const SizedBox(),
        tabletLayout: (context) => const SizedBox(),
        desktopLayout: (context) => const Tahlelscaffold());
  }
}
