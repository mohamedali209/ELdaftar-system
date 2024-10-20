import 'package:aldafttar/features/CollectionEldafaterview/manager/cubit/collectiondfater_cubit.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/eldafater.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/eldafater_body.dart';

import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<DraweritemlistState> drawerKey6 =
    GlobalKey<DraweritemlistState>();

class Eldafaterview extends StatefulWidget {
  const Eldafaterview({super.key});

  @override
  State<Eldafaterview> createState() => _EldafaterviewState();
}

final GlobalKey<ScaffoldState> key = GlobalKey();
final GlobalKey<DraweritemlistState> drawerKey =
    GlobalKey<DraweritemlistState>();

class _EldafaterviewState extends State<Eldafaterview> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectiondfaterCubit(FirebaseFirestore.instance),
      child: Scaffold(
        backgroundColor: Colors.black,
        key: key,
        drawer: MediaQuery.sizeOf(context).width < 600
            ? Customdrawer(drawerKey: drawerKey6)
            : null,
        body: AdaptiveLayout(
          mobileLayout: (context) => const EldafaterMobilelayout(),
          tabletLayout: (context) => const Eldafterbody(),
          desktopLayout: (context) => const Eldafterbody(),
        ),
      ),
    );
  }
}

class EldafaterMobilelayout extends StatelessWidget {
  const EldafaterMobilelayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            color: Colors.amber,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_left_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        // Rest of your mobile layout
        const Expanded(
          child: Eldafater(), // Your main content goes here
        ),
      ],
    );
  }
}
