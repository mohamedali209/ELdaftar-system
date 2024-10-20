import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class TitleSelling extends StatelessWidget {
  const TitleSelling({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'بيع',
            style: TextStyle(color: Colors.amber, fontSize: 16),
          ),
          Text(
            ' -الدفتر اليومي',
            style: Appstyles.regular25(context).copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class TitleBuying extends StatelessWidget {
  const TitleBuying({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'شراء',
            style: TextStyle(color: Colors.amber, fontSize: 16),
          ),
          Text(
            ' -الدفتر اليومي',
            style: Appstyles.regular25(context).copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
