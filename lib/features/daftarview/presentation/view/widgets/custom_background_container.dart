import 'package:flutter/material.dart';

class Custombackgroundcontainer extends StatelessWidget {
  const Custombackgroundcontainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 31, 30, 30),
          // Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}
