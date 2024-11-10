import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_expanded_container.dart';
import 'package:flutter/material.dart';

class Tahlelmobilelayout extends StatelessWidget {
  const Tahlelmobilelayout({super.key});

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
        // Rest of your mobile layout
         Expanded(
          child: Tahlelexpandedcontainer(), // Your main content goes here
        ),
      ],
    );
  }
}
