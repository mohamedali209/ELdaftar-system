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
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(child: DaftarelgardHeader()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(child: Gardrowheader()),
        SliverToBoxAdapter(
          child: Divider(color: Color.fromARGB(255, 114, 110, 110)),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(child: Listgard()),
      ],
    );
  }
}
