
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class DaftarcontainerItem extends StatelessWidget {
  const DaftarcontainerItem({
    super.key,
    required this.title,
    this.color,
  });
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xff161616),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      height: 40,
      width: MediaQuery.sizeOf(context).width * .12,
      child: Text(title,
          style: Appstyles.daftartodayheader(context).copyWith(color: color)),
    );
  }
}