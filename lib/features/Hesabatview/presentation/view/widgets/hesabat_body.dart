import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabatexpanded_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:flutter/material.dart';

final GlobalKey<DraweritemlistState> drawerKey3 =
    GlobalKey<DraweritemlistState>();

class Hesabatbody extends StatelessWidget {
  const Hesabatbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Customdrawer(
              drawerKey: drawerKey3,
            )),
        const Expanded(
            flex: 4,
            child:
                Hesabatcontainer() 
            ),
      ],
    );
  }
}
