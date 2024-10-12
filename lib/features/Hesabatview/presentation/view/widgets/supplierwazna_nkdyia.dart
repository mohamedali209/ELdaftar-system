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
    final formattedNum = double.tryParse(num)?.toStringAsFixed(2) ;

    return Column(
      
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                ' : $waznaornakdyia ',
                style: Appstyles.regular12cairo(context)
                    .copyWith(fontSize: 10, color: Colors.amber),
              ),
              Text(
                formattedNum??num,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
        const Divider()
      ],
    );
  }
}
