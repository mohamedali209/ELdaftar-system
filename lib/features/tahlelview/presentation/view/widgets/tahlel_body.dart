import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlelexpanded_column.dart';
import 'package:flutter/material.dart';

final GlobalKey<DraweritemlistState> drawerKey4 =
    GlobalKey<DraweritemlistState>();

class Tahlelbody extends StatelessWidget {
  const Tahlelbody({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Customdrawer(
              drawerKey: drawerKey4,
            )),
        const Expanded(flex: 4, child: TahlelexpandedColumn())
      ],
    );
  }
}
