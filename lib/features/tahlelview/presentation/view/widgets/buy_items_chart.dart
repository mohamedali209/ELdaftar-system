import 'package:aldafttar/features/tahlelview/presentation/view/widgets/items_list.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/items_pie_chart.dart';
import 'package:flutter/material.dart';

class Buyitemschart extends StatelessWidget {
  const Buyitemschart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              height: MediaQuery.sizeOf(context).height * .25,
              child: const ItemsCircleChart()),
          ItemsList(),
        ],
      ),
    );
  }
}
