import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BuyorSellItemsCircleChart extends StatefulWidget {
  final double sales;
  final double purchases;

  const BuyorSellItemsCircleChart({
    super.key,
    required this.sales,
    required this.purchases,
  });

  @override
  State<BuyorSellItemsCircleChart> createState() =>
      _BuyorSellItemsCircleChartState();
}

class _BuyorSellItemsCircleChartState extends State<BuyorSellItemsCircleChart> {
  int activeIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1, child: PieChart(getChartData()));
  }

  PieChartData getChartData() {
    double total = widget.sales + widget.purchases;

    // Calculate percentages
    double salesPercentage = (widget.sales / total) * 100;
    double purchasePercentage = (widget.purchases / total) * 100;

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
          showTitle: true,
          value: (widget.sales / total) * 100,
          radius: double.parse(salesPercentage.toStringAsFixed(2)),
          color: Colors.green,
          title:
              '${salesPercentage.toStringAsFixed(2)}%', // Optional: display percentage in the chart
        ),
        PieChartSectionData(
          showTitle: true,
          value: double.parse(purchasePercentage.toStringAsFixed(2)),
          radius: activeIndex == 1 ? 60 : 50,
          color: Colors.blue,
          title:
              '${purchasePercentage.toStringAsFixed(2)}%', // Optional: display percentage in the chart
        ),
      ],
    );
  }
}
