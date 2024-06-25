import 'package:aldafttar/features/Gardview/presentation/view/widgets/daftarelgard_header.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/gard_row_header.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/listof_gard.dart';
import 'package:flutter/material.dart';

class DaftarelGard extends StatelessWidget {
  const DaftarelGard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DaftarelgardHeader(),
        const SizedBox(
          height: 20,
        ),
        const Gardrowheader(),
        const SizedBox(
          height: 10,
        ),
        Listgard(),
      ],
    );
  }
}
