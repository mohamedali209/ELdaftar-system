import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BuyorSellItemsCircleChart extends StatefulWidget {
  const BuyorSellItemsCircleChart({super.key});

  @override
  State<BuyorSellItemsCircleChart> createState() => _BuyorSellItemsCircleChartState();
}

class _BuyorSellItemsCircleChartState extends State<BuyorSellItemsCircleChart> {
  int activeIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1, child: PieChart(getChartData()));
  }

  PieChartData getChartData() {
    return PieChartData(
      pieTouchData: PieTouchData(
        enabled: true,
        touchCallback: (p0, pietouchResponse) {
          setState(() {
            activeIndex =
                pietouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
          });
        },
      ),
      sectionsSpace: 0,
      sections: [
        PieChartSectionData(
          showTitle: false,
          value: 60, // Adjust percentage as needed
          radius: activeIndex == 0 ? 60 : 50,
          color: Colors.green,
        ),
        PieChartSectionData(
          showTitle: false,
          value: 40, // Adjust percentage as needed
          radius: activeIndex == 1 ? 60 : 50,
          color: Colors.blue,
        ),
      ],
    );
  }
}
