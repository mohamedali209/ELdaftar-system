
import 'package:flutter/material.dart';

class Custombackgroundblack extends StatelessWidget {
  const Custombackgroundblack({
    super.key, this.child,
  });
final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
       width: 500,
          decoration: BoxDecoration(
    color: const Color(0xff181818),
    borderRadius: BorderRadius.circular(10)),
    child:child ,
    );
  }
}