import 'package:aldafttar/features/tahlelview/presentation/view/widgets/circle_chart.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/custom_container_black.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/items_details_list.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Nesbetitems extends StatelessWidget {
  const Nesbetitems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Custombackgroundblack(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'نسبة المشغولات و السبائك من المبيعات',
            style:
                Appstyles.bold50(context).copyWith(fontWeight: FontWeight.w100),
          ),
          const Row(
            children: [
              SizedBox(width: 10,),
              SizedBox(
                height: 252,
                child: ItemsCircleChart(),
              ),
              Spacer(),
              Expanded(child: Itemsdetailschartlist())
            ],
          ),
        ],
      ),
    );
  }
}
