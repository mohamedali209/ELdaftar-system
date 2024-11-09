import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Supplierwaznaornkdyia extends StatelessWidget {
  const Supplierwaznaornkdyia({
    super.key,
    required this.waznaornakdyia,
    required this.num,
  });

  final String waznaornakdyia;
  final String num;

  @override
  Widget build(BuildContext context) {
    // Check if the label indicates it's a "wazna" field to format it as a double.
    final formattedNum = waznaornakdyia.contains('وزنة')
        ? double.tryParse(num)?.toStringAsFixed(2)
        : num; // Display `nakdyia` as a plain string

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                ' : $waznaornakdyia ',
                style: Appstyles.regular12cairo(context)
                    .copyWith(fontSize: 12, color: Colors.amber),
              ),
              Text(
                formattedNum ?? num, // Use formatted or plain text based on label
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
