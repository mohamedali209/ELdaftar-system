import 'package:aldafttar/features/Gardview/presentation/view/widgets/gardfawry_scaffold.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:flutter/material.dart';

class Gardfawryview extends StatelessWidget {
  const Gardfawryview({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (context) => const SizedBox(),
      tabletLayout: (context) => const SizedBox(),
      desktopLayout: (context) => const Gardfawyscaffold(),
    );
  }
}
