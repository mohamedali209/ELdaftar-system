import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Loginbutton extends StatelessWidget {
  const Loginbutton({
    super.key,
    this.onPressed, required this.text,
  });
  final void Function()? onPressed;
  final String text ;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.amber, // Color on the left
            Color(0xFFBF8F00), // Color on the right
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make background transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(
          text,          style: Appstyles.regular12cairo(context)
              .copyWith(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
