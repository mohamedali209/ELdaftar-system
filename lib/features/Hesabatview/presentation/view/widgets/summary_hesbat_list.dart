import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftar_item.dart';
import 'package:flutter/material.dart';

class Summaryhesabatlist extends StatefulWidget {
  const Summaryhesabatlist({super.key});

  @override
  State<Summaryhesabatlist> createState() => _SummaryhesabatlistState();
}

class _SummaryhesabatlistState extends State<Summaryhesabatlist> {
 final List<DaftarheaderModel> items = [
    DaftarheaderModel(
      title: 'وزنة 18',
      subtitle: '2538.35',
    ),
    DaftarheaderModel(
      title: 'وزنة 21',
      subtitle: '1750.6',
    ),
      DaftarheaderModel(
      title: 'اجمالي الوزنة',
      subtitle: '4250.88',
    ),
    DaftarheaderModel(
      title: 'عدد الحسابات',
      subtitle: '4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) => SummaryHeadersDaftaritem(daftarmodel: items[index]),),
    );
  }
}