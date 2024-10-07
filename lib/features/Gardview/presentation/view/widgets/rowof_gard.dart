import 'package:aldafttar/features/Gardview/presentation/model/row_gard_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/daftar_container_item.dart';
import 'package:flutter/material.dart';

class Rowofgard extends StatelessWidget {
  const Rowofgard({
    super.key,
    required this.gardmodel,
  });

  final Gardmodel gardmodel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DaftarcontainerItem(
              title: gardmodel.no3,
              color: Colors.white,
            ),

            DaftarcontainerItem(
              title: gardmodel.num21,
              color: Colors.white,
            ),

            DaftarcontainerItem(
              title: gardmodel.num18,
              color: Colors.white,
            ),

            DaftarcontainerItem(
              title: gardmodel.wazn18,
              color: Colors.white,
            ),

            DaftarcontainerItem(
              title: gardmodel.wazn21,
              color: Colors.white,
            ),

            // Add more DaftarcontainerItem widgets as needed
          ],
        ),
        const Divider()
      ],
    );
  }
}
