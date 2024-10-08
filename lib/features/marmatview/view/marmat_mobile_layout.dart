import 'package:flutter/material.dart';

class MarmatmobileLayout extends StatelessWidget {
  const MarmatmobileLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            color: Colors.amber,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_left_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ],
    );
  }
}
