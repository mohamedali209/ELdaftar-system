import 'package:aldafttar/features/tahlelview/presentation/view/models/tahlel_chartmodel.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.itemDetailsModel});

  final ItemDetailsModel itemDetailsModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: ShapeDecoration(
          color: itemDetailsModel.color,
          shape: const OvalBorder(),
        ),
      ),
      title: Text(itemDetailsModel.title,
          style: Appstyles.regular12cairo(context)),
    );
  }
}

