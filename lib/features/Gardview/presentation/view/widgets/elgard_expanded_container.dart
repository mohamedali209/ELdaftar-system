import 'package:aldafttar/features/Gardview/presentation/view/widgets/dafarelgard.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/gard_header.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/lower_body.dart';
import 'package:flutter/material.dart';

class Gard extends StatelessWidget {
  const Gard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: GardHeader()),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            child: Custombackgroundcontainer(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: DaftarelGard(),
            )),
          ),
        ),
        SliverToBoxAdapter(child: Lowerbody())
      ],
    );
  }
}

