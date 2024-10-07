import 'package:aldafttar/features/Gardview/presentation/view/widgets/elgard_expanded_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:flutter/material.dart';
  final GlobalKey<DraweritemlistState> drawerKey2 = GlobalKey<DraweritemlistState>();

class Gardfawrybody extends StatelessWidget {
 const Gardfawrybody({super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Customdrawer(drawerKey: drawerKey2)),
        const Expanded(flex: 4, child: Gard())
      ],
    );
  }
}
