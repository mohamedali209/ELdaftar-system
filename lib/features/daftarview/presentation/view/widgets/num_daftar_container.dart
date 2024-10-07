import 'package:flutter/material.dart';

class Numdaftarcontainer extends StatelessWidget {
  const Numdaftarcontainer({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xff161616),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      height: 40,
      width: 40,
      child: Text(
        title,
        style: const TextStyle(color: Colors.amber),
      ),
    );
  }
}
