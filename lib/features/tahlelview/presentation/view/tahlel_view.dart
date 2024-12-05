import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_cubit.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_body.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/tahlel_mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<DraweritemlistState> drawerKey =
    GlobalKey<DraweritemlistState>();

class Tahlelview extends StatefulWidget {
  const Tahlelview({super.key});

  @override
  State<Tahlelview> createState() => _TahlelviewState();
}

class _TahlelviewState extends State<Tahlelview> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchInsightsCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        key: key,
        drawer: MediaQuery.sizeOf(context).width < 600
            ? Customdrawer(drawerKey: drawerKey)
            : null,
        body: AdaptiveLayout(
            mobileLayout: (context) => const Tahlelmobilelayout(),
            tabletLayout: (context) => const Tahlelbody(),
            desktopLayout: (context) => const Tahlelbody()),
      ),
    );
  }
}
