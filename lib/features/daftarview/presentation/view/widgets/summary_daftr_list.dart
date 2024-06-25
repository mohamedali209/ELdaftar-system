import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftar_item.dart';
import 'package:flutter/material.dart';

class Summarydftarlist extends StatelessWidget {
  Summarydftarlist({super.key});
  final List<DaftarheaderModel> items = [
    DaftarheaderModel(
      title: 'مبيعات اليوم',
      subtitle: '125,000',
    ),
    DaftarheaderModel(
      title: 'شراء اليوم',
      subtitle: '250,000',
    ),
      DaftarheaderModel(
      title: ' الكسر',
      subtitle: '60.25',
    ),
    DaftarheaderModel(
      title: 'عدد الزبائن',
      subtitle: '15',
    ),
    DaftarheaderModel(
      title: 'النقدية المتاحة',
      subtitle: '125,000',
    ),
    DaftarheaderModel(
      title: 'مرتجعات',
      subtitle: '0',
    ), 
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SummaryHeadersDaftaritem(
            daftarmodel: items[index], 
          );
        },
      ),
    );
  }
}
