import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ItemsCircleChart extends StatefulWidget {
  const ItemsCircleChart({super.key});

  @override
  State<ItemsCircleChart> createState() => _ItemsCircleChartState();
}

class _ItemsCircleChartState extends State<ItemsCircleChart> {
  int activeIndex = -1;

  final List<String> items = [
    'خاتم',
    'دبلة',
    'سلسلة',
    'حلق',
    'محبس',
    'انسيال',
    'اسورة',
    'تعليقة',
    'كوليه',
    'غوايش',
    'سبائك',
    'جنيهات'
  ];

  final List<Color> colors = [
    const Color(0xFF5BC47B),
    const Color(0xFFDF4EE3),
    const Color(0xFFEB8D3F),
    Colors.red,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.green,
    Colors.yellow,
    Colors.pink,
    Colors.brown,
    Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(getChartData()),
    );
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
      sections: List.generate(items.length, (index) {
        return PieChartSectionData(
          showTitle: true,
          value: (index + 1) * 10, // Example values
          radius: activeIndex == index ? 60 : 50,
          color: colors[index],
        );
      }),
    );
  }
}

