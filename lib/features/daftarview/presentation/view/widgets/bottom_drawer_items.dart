import 'package:aldafttar/features/daftarview/presentation/view/models/drawer_item_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Bottomdraweritems extends StatelessWidget {
  const Bottomdraweritems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: SizedBox()),
        GestureDetector(
          onTap: () {
            GoRouter.of(context).go(AppRouter.kaddemployee);
          },
          child: const Inactiveitem(
            drawerItemModel: DrawerItemModel(
                title: 'اضافة موظف', image: 'assets/images/plus2.svg'),
          ),
        ),
        GestureDetector(
          onTap: ()  {
            FirebaseAuth.instance.signOut();

            // Navigate to the login screen or any other screen after logout
            GoRouter.of(context).go(AppRouter.kloginview);
          },
          child: const Inactiveitem(
            drawerItemModel: DrawerItemModel(
                title: 'تسجيل خروج', image: 'assets/images/logout.svg'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
