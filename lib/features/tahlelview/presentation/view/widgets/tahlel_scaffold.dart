import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_body.dart';
import 'package:flutter/material.dart';

class Tahlelscaffold extends StatelessWidget {
  const Tahlelscaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/backkkk.png'),
                  fit: BoxFit.cover)),
          child: const Tahlelbody()),
    );
  }
}
