import 'package:aldafttar/features/daftarview/presentation/view/widgets/daftar_container_item.dart';
import 'package:flutter/material.dart';

class Gardrowheader extends StatelessWidget {
  const Gardrowheader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DaftarcontainerItem(title: 'الصنف'),
        SizedBox(
          width: 30,
        ),
        DaftarcontainerItem(title: 'عدد 21'),
        SizedBox(
          width: 30,
        ),
        DaftarcontainerItem(title: 'عدد 18'),
        SizedBox(
          width: 30,
        ),
        DaftarcontainerItem(title: 'الوزن الاجمالي'),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
