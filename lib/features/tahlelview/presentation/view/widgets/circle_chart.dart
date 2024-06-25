import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ItemsCircleChart extends StatefulWidget {
  const ItemsCircleChart({super.key});

  @override
  State<ItemsCircleChart> createState() => _ItemsCircleChartState();
}

class _ItemsCircleChartState extends State<ItemsCircleChart> {
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
          value: 40,
          radius: activeIndex == 0 ? 60 : 50,
          color: const Color(0xFF5BC47B),
        ),
        PieChartSectionData(
          value: 25,
          radius: activeIndex == 1 ? 60 : 50,
          color: const Color(0xFFDF4EE3),
        ),
        PieChartSectionData(
          value: 20,
          radius: activeIndex == 2 ? 60 : 50,
          color: const Color(0xFFEB8D3F),
        ),
        PieChartSectionData(
            value: 15, radius: activeIndex == 3 ? 60 : 50, color: Colors.red),
      ],
    );
  }
}
