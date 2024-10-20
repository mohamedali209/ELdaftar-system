import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class TitleexpensesCollection extends StatelessWidget {
  const TitleexpensesCollection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'المصاريف',
            style: TextStyle(
                color: Colors.amber, fontSize: 16),
          ),
          Text(
            ' -الدفتر ',
            style: Appstyles.regular25(context)
                .copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class TitleBuyingCollection extends StatelessWidget {
  const TitleBuyingCollection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'شراء',
            style: TextStyle(
                color: Colors.amber, fontSize: 16),
          ),
          Text(
            ' -الدفتر ',
            style: Appstyles.regular25(context)
                .copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class TitlesellingCollection extends StatelessWidget {
  const TitlesellingCollection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'بيع',
            style: TextStyle(
                color: Colors.amber, fontSize: 16),
          ),
          Text(
            ' -الدفتر ',
            style: Appstyles.regular25(context)
                .copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
