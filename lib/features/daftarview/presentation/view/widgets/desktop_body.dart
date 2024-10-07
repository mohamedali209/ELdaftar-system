import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/eldaftarbutton_body.dart';
import 'package:flutter/material.dart';

class Desktopbody extends StatelessWidget {
  Desktopbody({super.key});

  final GlobalKey<DraweritemlistState> drawerKey = GlobalKey<DraweritemlistState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Customdrawer(drawerKey: drawerKey)),
        const Expanded(flex: 4, child: DaftarTodayContent())
      ],
    );
  }
}
