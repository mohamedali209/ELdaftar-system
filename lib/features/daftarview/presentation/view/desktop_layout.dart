import 'package:aldafttar/features/daftarview/presentation/view/manager/cubit/items_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/summarylist/cubit/summary_item_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/desktop_body.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<DraweritemlistState> drawerKey =
    GlobalKey<DraweritemlistState>();

class Daftarview extends StatefulWidget {
  const Daftarview({
    super.key,
  });

  @override
  State<Daftarview> createState() => _DaftarviewState();
}

class _DaftarviewState extends State<Daftarview> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SummaryDftarCubit>(
          create: (context) => SummaryDftarCubit()..fetchData(),
        ),
        BlocProvider<ItemsCubit>(
          create: (context) => ItemsCubit(), // Pass SummaryDftarCubit
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        key: key,
        drawer: MediaQuery.sizeOf(context).width < 600
            ? Customdrawer(drawerKey: drawerKey)
            : null,
        body: AdaptiveLayout(
          mobileLayout: (context) => const DaftarscreenMobile(),
          tabletLayout: (context) => Desktopbody(),
          desktopLayout: (context) => Desktopbody(),
        ),
      ),
    );
  }
}
