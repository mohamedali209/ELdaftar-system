import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/buyorsell_header_period.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/custom_line_chart.dart';
import 'package:flutter/material.dart';

class Tahlelexpandedcontainer extends StatefulWidget {
  const Tahlelexpandedcontainer({super.key});

  @override
  TahlelexpandedcontainerState createState() => TahlelexpandedcontainerState();
}

class TahlelexpandedcontainerState extends State<Tahlelexpandedcontainer> {
  String selectedPeriod = 'سنوي';

  final Map<String, List<double>> salesData = {
    'اسبوعي': [5, 10, 7, 20, 25, 30, 35],
    'شهري': [
      10,
      50,
      70,
      40,
      90,
      100,
      130,
      150,
      80,
      110,
      140,
      500,
      600,
      700,
      800,
      900,
      1000,
      100,
      200,
      300,
      400,
      500,
      600,
      700,
      800,
      900,
    ],
    'سنوي': [120, 150, 130, 180, 160, 200, 250, 270, 300, 350, 400, 500],
  };

  final Map<String, List<double>> purchaseData = {
    'اسبوعي': [4, 9, 14, 19, 24, 29, 34],
    'شهري': [
      5,
      30,
      60,
      30,
      70,
      80,
      120,
      140,
      70,
      100,
      120,
      130,
      140,
      150,
      160,
      170,
      180,
      190,
      200,
    ],
    'سنوي': [100, 120, 110, 140, 150, 130, 160, 170, 190, 220, 240, 300],
  };

  void onPeriodChanged(String period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Custombackgroundcontainer(
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Column(
                  children: [
                    PeriodHeader(
                      title: 'المبيعات',
                      selectedPeriod: selectedPeriod,
                      onPeriodChanged: onPeriodChanged,
                    ),
                    CustomLineChart(dataPoints: salesData[selectedPeriod]!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Custombackgroundcontainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    PeriodHeader(
                      title: 'الشراء',
                      selectedPeriod: selectedPeriod,
                      onPeriodChanged: onPeriodChanged,
                    ),
                    CustomLineChart(dataPoints: purchaseData[selectedPeriod]!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 