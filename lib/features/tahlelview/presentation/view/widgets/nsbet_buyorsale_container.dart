import 'package:aldafttar/features/tahlelview/presentation/view/models/tahlel_chartmodel.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/custom_container_black.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/items_circle_buyorsale_chart.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/items_details_listile.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class NsbetbuyorsaleContainer extends StatelessWidget {
  const NsbetbuyorsaleContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Custombackgroundblack(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          'نسبة البيع و الشراء  ',
          style:
              Appstyles.bold50(context).copyWith(fontWeight: FontWeight.w100),
        ),
        const SizedBox(
          height: 20,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 250,
              child: ItemsCircleChartSaleorbuy(),
            ),
            Spacer(),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    ItemDetails(
                        itemDetailsModel: ItemDetailsModel(
                            color: Color(0xFF5BC47B), title: 'بيع')),
                    ItemDetails(
                        itemDetailsModel:
                            ItemDetailsModel(color: Colors.blue, title: 'شراء'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
