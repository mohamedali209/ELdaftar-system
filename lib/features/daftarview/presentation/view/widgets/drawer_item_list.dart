import 'package:aldafttar/features/daftarview/presentation/view/manager/drawercubit/cubit/drawer_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/drawer_item_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Draweritemlist extends StatefulWidget {
  const Draweritemlist({super.key});

  @override
  State<Draweritemlist> createState() => DraweritemlistState();
}

class DraweritemlistState extends State<Draweritemlist> {
  late List<DrawerItemModel> items;

  @override
  void initState() {
    super.initState();
    items = [
      DrawerItemModel(
        onTap: () {
          context.read<DrawerCubit>().updateIndex(0);
          GoRouter.of(context).go(AppRouter.kDaftarview);
        },
        title: 'الدفتر اليومي',
        image: 'assets/images/Pie chart.svg',
      ),
      DrawerItemModel(
        onTap: () {
          context.read<DrawerCubit>().updateIndex(1);
          GoRouter.of(context).go(AppRouter.kgardview);
        },
        title: 'جرد فوري',
        image: 'assets/images/gardfawry.svg',
      ),
      DrawerItemModel(
        onTap: () {
          context.read<DrawerCubit>().updateIndex(2);
          GoRouter.of(context).go(AppRouter.khesabatview);
        },
        title: 'حسابات',
        image: 'assets/images/hesabat.svg',
      ),
        DrawerItemModel(
        onTap: () {
          context.read<DrawerCubit>().updateIndex(3);
          GoRouter.of(context).go(AppRouter.kmarmatview);
        },
        title: 'المرمات',
        image: 'assets/images/marmat.svg',
        
      ),
      DrawerItemModel(
        onTap: () {
          context.read<DrawerCubit>().updateIndex(4);
          GoRouter.of(context).go(AppRouter.ktahlelView);
        },
        title: 'تحليلات',
        image: 'assets/images/tahlelat.svg',
      ),
        DrawerItemModel(
        onTap: () {
          context.read<DrawerCubit>().updateIndex(5);
          GoRouter.of(context).go(AppRouter.kcollectiondafterView);
        },
        title: 'الدفاتر',
        image: 'assets/images/reshot-icon-stacked-books-PS57ZD98BR.svg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: BlocBuilder<DrawerCubit, int>(
        builder: (context, activeIndex) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                context.read<DrawerCubit>().updateIndex(index);
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
          );
        },
      ),
    );
  }
}
