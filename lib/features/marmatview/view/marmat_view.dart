import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/features/marmatview/manager/cubit/marmat_cubit.dart';
import 'package:aldafttar/features/marmatview/view/marmat_mobile_layout.dart';
import 'package:aldafttar/features/marmatview/view/widgets/marmat_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarmatScreen extends StatefulWidget {
  const MarmatScreen({super.key});

  @override
  State<MarmatScreen> createState() => _MarmatScreenState();
}

class _MarmatScreenState extends State<MarmatScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final GlobalKey<DraweritemlistState> drawerKey =
      GlobalKey<DraweritemlistState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarmatCubit( firestore: FirebaseFirestore.instance),
      child: Scaffold(
        key: key,
        drawer: MediaQuery.sizeOf(context).width < 600
            ? Customdrawer(drawerKey: drawerKey)
            : null,
        backgroundColor: Colors.black,
        body: AdaptiveLayout(
            mobileLayout: (context) => const MarmatmobileLayout(),
            tabletLayout: (context) => const Marmatbody(),
            desktopLayout: (context) => const Marmatbody()),
      ),
    );
  }
}
