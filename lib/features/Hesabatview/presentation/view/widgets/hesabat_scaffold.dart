import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabat_body.dart';
import 'package:flutter/material.dart';

class Hesabatscaffold extends StatelessWidget {
  const Hesabatscaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/backkkk.png'),
              fit: BoxFit.cover)),
      child: const Hesabatbody(),
    ));
  }
}