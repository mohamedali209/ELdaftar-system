import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color color;

  const CustomLoadingIndicator({
    super.key,
    this.size = 30.0, // Default size
    this.color = Colors.amber, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 6.0, // Adjust the thickness
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
