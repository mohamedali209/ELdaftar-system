import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;

  const CustomLoadingIndicator({
    super.key,
    this.size = 100.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Lottie.asset(
          'assets/lottie/Animation - 1730555800350.json', // Change this to your animation file path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
