import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class PeriodHeader extends StatelessWidget {
  final String title;
  final String selectedPeriod; // Pass selected period here
  final Function(String) onPeriodChanged;

  const PeriodHeader(
      {super.key,
      required this.title,
      required this.selectedPeriod,
      required this.onPeriodChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Appstyles.daftartodayheader(context).copyWith(fontSize: 25),
        ),
        DropdownButton<String>(
          padding: const EdgeInsets.all(0),
          value: selectedPeriod,
          icon: const Icon(Icons.arrow_drop_down,
              color: Colors.amber), // Icon color to amber
          style: const TextStyle(
              color: Colors.amber, fontSize: 16), // Set text color to amber
          borderRadius: BorderRadius.circular(10),
          underline: Container(
              height: 1, color: Colors.amber), // Underline color to amber
          onChanged: (String? newValue) {
            if (newValue != null) {
              onPeriodChanged(newValue); // Notify parent about the change
            }
          },
          items: <String>['اسبوعي', 'شهري', 'سنوي']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
