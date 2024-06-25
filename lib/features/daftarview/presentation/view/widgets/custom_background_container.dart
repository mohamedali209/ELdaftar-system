import 'package:flutter/material.dart';

class Custombackgroundcontainer extends StatelessWidget {
  const Custombackgroundcontainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 112, 111, 111)),
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}
