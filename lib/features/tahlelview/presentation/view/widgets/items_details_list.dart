import 'package:aldafttar/features/tahlelview/presentation/view/models/tahlel_chartmodel.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/items_details_listile.dart';
import 'package:flutter/material.dart';

class Itemsdetailschartlist extends StatelessWidget {
  const Itemsdetailschartlist({super.key});

  static const items = [
    ItemDetailsModel(
      color: Color(0xFFEB8D3F),
      title: 'خواتم',
    ),
    ItemDetailsModel(
      color: Color(0xFFDF4EE3),
      title: 'سلاسل',
    ),
    ItemDetailsModel(
      color: Color(0xFF5BC47B),
      title: 'دبل',
    ),
    ItemDetailsModel(color: Colors.red, title: 'سبائك'),
    ItemDetailsModel(color: Colors.blue, title: 'انسيالات'),
    ItemDetailsModel(color: Colors.cyanAccent, title: 'غوايش'),
    ItemDetailsModel(color: Color.fromARGB(255, 0, 47, 255), title: 'حلقان'),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          ItemDetails(itemDetailsModel: items[index]),
    );
  }
}
