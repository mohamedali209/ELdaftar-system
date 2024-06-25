import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ItemsCircleChartSaleorbuy extends StatefulWidget {
  const ItemsCircleChartSaleorbuy({super.key});

  @override
  State<ItemsCircleChartSaleorbuy> createState() =>
      _ItemsCircleChartSaleorbuyState();
}

class _ItemsCircleChartSaleorbuyState extends State<ItemsCircleChartSaleorbuy> {
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
          activeIndex =
              pietouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
          setState(() {});
        },
      ),
      sectionsSpace: 0,
      sections: [
        PieChartSectionData(
          showTitle: true,
          value: 60,
          radius: activeIndex == 0 ? 60 : 50,
          color: const Color(0xFF5BC47B),
        ),
        PieChartSectionData(
          value: 40,
          radius: activeIndex == 1 ? 60 : 50,
          color: Colors.blue,
        ),
      ],
    );
  }
}
