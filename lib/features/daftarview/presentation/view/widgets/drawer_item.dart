import 'package:aldafttar/features/daftarview/presentation/view/models/drawer_item_model.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Draweritem extends StatelessWidget {
  const Draweritem(
      {super.key,
      required this.drawerItemModel,
      required this.isactive,
      this.onTap});
  final DrawerItemModel drawerItemModel;
  final bool isactive;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return isactive
        ? Activeitem(onTap: onTap, drawerItemModel: drawerItemModel)
        : Inactiveitem(drawerItemModel: drawerItemModel);
  }
}

class Inactiveitem extends StatelessWidget {
  const Inactiveitem({
    super.key,
    required this.drawerItemModel,
  });

  final DrawerItemModel drawerItemModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        drawerItemModel.image,
        height: 15,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child:
              Text(drawerItemModel.title, style: Appstyles.regular25(context))),
    );
  }
}

class Activeitem extends StatelessWidget {
  const Activeitem({
    super.key,
    required this.drawerItemModel,
    this.onTap,
  });

  final DrawerItemModel drawerItemModel;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: SvgPicture.asset(
          drawerItemModel.image,
          colorFilter: const ColorFilter.mode(
            Colors.amber,
            BlendMode.srcIn,
          ),
        ),
        title: Text(drawerItemModel.title,
            style: Appstyles.regular25(context).copyWith(color: Colors.amber)),
      ),
    );
  }
}
