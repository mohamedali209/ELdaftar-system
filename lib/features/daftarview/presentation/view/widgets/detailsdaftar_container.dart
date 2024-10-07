import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class DetailsDaftarcontainer extends StatelessWidget {
  const DetailsDaftarcontainer({
    super.key,
    required this.details,
    this.color,
    required this.icon,
    required this.sizeicon, this.onPressed,
  });
  final String details;
  final Color? color;
  final IconData icon;
  final double sizeicon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xff161616),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      height: 40,
      width: MediaQuery.sizeOf(context).width * .25,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(details,
              style:
                  Appstyles.daftartodayheader(context).copyWith(color: color)),
          const Spacer(),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.amber,
              size: sizeicon,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
