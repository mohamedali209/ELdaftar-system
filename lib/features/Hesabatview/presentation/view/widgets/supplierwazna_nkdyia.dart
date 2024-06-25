
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
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 155, 155, 155).withOpacity(0.2),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            ' : $waznaornakdyia ',
            style: Appstyles.regular12cairo(context).copyWith(fontSize: 15,color: Colors.amber),
          ),
          Text(num),
        ],
      ),
    );
  }
}
