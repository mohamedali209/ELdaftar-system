import 'package:aldafttar/features/daftarview/presentation/view/widgets/daftar_container_item.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/detailsdaftar_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/num_daftar_container.dart';
import 'package:flutter/material.dart';

class Sellorbuyitems extends StatelessWidget {
  const Sellorbuyitems({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Numdaftarcontainer(title: '#'),
        DetailsDaftarcontainer(
          onPressed: () {},
          sizeicon: 25,
          icon: Icons.add,
          color: Colors.amber,
          details: 'الصنف',
        ),
        const DaftarcontainerItem(title: 'العدد'),
        const DaftarcontainerItem(title: 'الجرام'),
        const DaftarcontainerItem(
          title: 'السعر',
        ),
      ],
    );
  }
}
