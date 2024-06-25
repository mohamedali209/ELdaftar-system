import 'package:aldafttar/features/daftarview/presentation/view/models/drawer_item_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bottomdraweritems extends StatelessWidget {
  const Bottomdraweritems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
crossAxisAlignment:CrossAxisAlignment.start ,
      children: [
        Expanded(child: SizedBox()),
        Inactiveitem(
          drawerItemModel: DrawerItemModel(
              title: 'اعدادات', image: 'assets/images/settings.svg'),
        ),
        Inactiveitem(
          drawerItemModel: DrawerItemModel(
              title: 'تسجيل خروج', image: 'assets/images/logout.svg'),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
