import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/desktop_body.dart';
import 'package:flutter/material.dart';

class Desktoplayout extends StatelessWidget {
  const Desktoplayout({super.key});
  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobileLayout: (context) => const SizedBox(),
      tabletLayout: (context) => const SizedBox(),
      desktopLayout: (context) => const Daftarview(),
    );
  }
}

class Daftarview extends StatelessWidget {
  const Daftarview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/backkkk.png'),
                  fit: BoxFit.cover)),
          child: const Desktopbody()),
    );
  }
}
