import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ItemsCircleChart extends StatefulWidget {
  final Map<String, double> salesPercentageData;
  final List<Color> colors;

  const ItemsCircleChart({
    super.key,
    required this.salesPercentageData,
    required this.colors, // Accept colors as a parameter
  });

  @override
  State<ItemsCircleChart> createState() => _ItemsCircleChartState();
}

class _ItemsCircleChartState extends State<ItemsCircleChart> {
  int activeIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        getChartData(),
        swapAnimationDuration: const Duration(milliseconds: 1000), // Duration of animation
      ),
    );
  }

  PieChartData getChartData() {
    final entries = widget.salesPercentageData.entries.toList();
    double total = entries.fold(0.0, (sum, entry) => sum + entry.value); // Calculate total value
    
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
      sections: List.generate(entries.length, (index) {
        final entry = entries[index];
        double percentage = (entry.value / total) * 100;
        bool isTouched = index == activeIndex;

        return PieChartSectionData(
          showTitle: isTouched? true : false,
          titlePositionPercentageOffset: isTouched ? 1.5 : 0.1, // Move title outside when touched
          title: '${entry.key} (${percentage.toStringAsFixed(1)}%)',
          value: entry.value,
          color: widget.colors[index % widget.colors.length],
          radius: isTouched ? 60 : 50, // Increase radius when touched
          // Animation settings
          titleStyle: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        );
      }),
    );
  }
}
