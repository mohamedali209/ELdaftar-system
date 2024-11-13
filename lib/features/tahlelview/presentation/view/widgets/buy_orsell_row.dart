import 'package:aldafttar/features/tahlelview/presentation/view/widgets/buy_or_sell_chart.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/color_item.dart';
import 'package:flutter/material.dart';

class Buyorselltahlel extends StatelessWidget {
  const Buyorselltahlel({
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
              child: const BuyorSellItemsCircleChart()),
          const SizedBox(
            width: 100,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LegendItem(color: Colors.green, label: 'بيع'),
                LegendItem(color: Colors.blue, label: 'شراء'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
