import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabat_grid.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/summary_hesbat_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/lower_body.dart';
import 'package:flutter/material.dart';

class Hesabatcontainer extends StatelessWidget {
  const Hesabatcontainer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Summaryhesabatlist(),
        Expanded(child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Custombackgroundcontainer(child: Hesabatgridview()),
        )),
        Lowerbody()
      ],
    );
  }
}
