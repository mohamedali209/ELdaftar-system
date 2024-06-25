import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Lowerbody extends StatelessWidget {
  const Lowerbody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'برنامج الدفتر',
          style: Appstyles.bold50(context),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الدفتر',
              style: Appstyles.regular12cairo(context).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'جرد فوري',
              style: Appstyles.regular12cairo(context).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              ' حسابات',
              style: Appstyles.regular12cairo(context).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              ' تحليلات',
              style: Appstyles.regular12cairo(context).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ],
    );
  }
}
