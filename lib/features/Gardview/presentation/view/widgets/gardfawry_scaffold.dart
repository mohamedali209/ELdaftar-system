import 'package:aldafttar/features/Gardview/presentation/view/widgets/gardview_body.dart';
import 'package:flutter/material.dart';

class Gardfawyscaffold extends StatelessWidget {
  const Gardfawyscaffold({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backkkk.png'),
                fit: BoxFit.cover)),
        child: const Gardfawrybody(),
      ),
    );
  }
}
