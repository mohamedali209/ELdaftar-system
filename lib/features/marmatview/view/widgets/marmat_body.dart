import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/features/marmatview/view/widgets/marmat_expanded_container.dart';
import 'package:flutter/material.dart';

final GlobalKey<DraweritemlistState> drawerKey5 =
    GlobalKey<DraweritemlistState>();

class Marmatbody extends StatelessWidget {
  const Marmatbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Customdrawer(
              drawerKey: drawerKey5,
            )),
        const Expanded(flex: 4, child: Marmatexpandedcontainer()),
      ],
    );
  }
}
