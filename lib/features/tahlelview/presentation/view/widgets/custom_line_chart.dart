import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<double> dataPoints;

  const CustomLineChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      height: 300,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(
                    showTitles: false, interval: 50, reservedSize: 40),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40,),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    // Handle case when there is less data than months
                    if (dataPoints.isNotEmpty && value < dataPoints.length) {
                      return Text(
                        (value.toInt() + 1).toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
            gridData: const FlGridData(
              show: false,
              drawVerticalLine: true,
              horizontalInterval: 50,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: Colors.amber,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
