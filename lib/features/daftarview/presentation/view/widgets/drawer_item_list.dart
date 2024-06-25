import 'package:aldafttar/features/Hesabatview/presentation/view/hesabat_view.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/drawer_item_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/tahlel_view.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<DraweritemlistState> drawerKey =
    GlobalKey<DraweritemlistState>();

class Draweritemlist extends StatefulWidget {
  const Draweritemlist({super.key});
  @override
  State<Draweritemlist> createState() => DraweritemlistState();
}

class DraweritemlistState extends State<Draweritemlist> {
  late List<DrawerItemModel> items;
  int activeIndex = 0;
  @override
  void initState() {
    super.initState();
    items = [
      DrawerItemModel(
        onTap: () {
          setState(() {
            activeIndex = 0;
          });
          GoRouter.of(context).go(AppRouter.kDaftarview);
        },
        title: 'الدفتر',
        image: 'assets/images/sales_icon.svg',
      ),
      DrawerItemModel(
        onTap: () {
          setState(() {
            activeIndex = 1;
          });
          GoRouter.of(context).go(AppRouter.kgardview);
        },
        title: 'جرد فوري',
        image: 'assets/images/reports2_icon.svg',
      ),
      DrawerItemModel(
        onTap: () {
          setState(() {
            activeIndex = 2;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Hesabatview()),
          );
        },
        title: 'حسابات',
        image: 'assets/images/Hesab_icon.svg',
      ),
      DrawerItemModel(
        onTap: () {
          setState(() {
            activeIndex = 3;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Tahlelview()),
          );
        },
        title: 'تحليلات',
        image: 'assets/images/reports_icon.svg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              activeIndex = index;
            });
            items[index].onTap?.call();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Draweritem(
              isactive: activeIndex == index,
              drawerItemModel: items[index],
            ),
          ),
        ),
      ),
    );
  }
}
