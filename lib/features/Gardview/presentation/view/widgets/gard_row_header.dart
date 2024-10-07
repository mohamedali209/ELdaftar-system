import 'package:aldafttar/features/daftarview/presentation/view/widgets/daftar_container_item.dart';
import 'package:flutter/material.dart';

class Gardrowheader extends StatelessWidget {
  const Gardrowheader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DaftarcontainerItem(color: Colors.white, title: 'الصنف'),
        DaftarcontainerItem(color: Colors.white, title: 'عدد 21'),
        DaftarcontainerItem(color: Colors.white, title: 'عدد 18'),
        DaftarcontainerItem(color: Colors.white, title: 'الوزن 18'),
        DaftarcontainerItem(color: Colors.white, title: 'الوزن 21'),
      ],
    );
  }
}
