import 'package:aldafttar/features/daftarview/presentation/view/widgets/lower_body.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sellorbuy.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftr_list.dart';
import 'package:flutter/material.dart';

class DaftarToday extends StatelessWidget {
  const DaftarToday({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Summarydftarlist(),
        ),

        const SliverToBoxAdapter(
          child: SellingorBuying(),
        ),
        const SliverToBoxAdapter(
          child: Divider(
            color: Color.fromARGB(255, 114, 110, 110),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Lowerbody(),
          ),
        )
      ],
    );
  }
}
