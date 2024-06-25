
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/nsbet_buyorsale_container.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/nsbet_items.dart';
import 'package:flutter/material.dart';

class FirsttahlelList extends StatelessWidget {
  const FirsttahlelList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 410,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Nesbetitems(),
          ),
          SizedBox(
            width: 30,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: NsbetbuyorsaleContainer(),
          ),
        ],
      ),
    );
  }
}
