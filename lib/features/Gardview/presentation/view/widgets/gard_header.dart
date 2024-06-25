import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftar_item.dart';
import 'package:flutter/material.dart';

class GardHeader extends StatelessWidget {
  const GardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SummaryHeadersDaftaritem(
              daftarmodel:
                  DaftarheaderModel(title: 'عيار 18', subtitle: '3650.75')),
          SummaryHeadersDaftaritem(
              daftarmodel:
                  DaftarheaderModel(title: 'عيار 21', subtitle: '1743.30')),
          SummaryHeadersDaftaritem(
              daftarmodel:
                  DaftarheaderModel(title: 'الاجمالي', subtitle: '5850.69')),
        ],
      ),
    );
  }
}
