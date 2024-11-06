import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/transaction/cubit/transaction_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabat_scaffold.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabatexpanded_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/desktop_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Hesabatview extends StatefulWidget {
  const Hesabatview({super.key});

  @override
  State<Hesabatview> createState() => _HesabatviewState();
}

final GlobalKey<ScaffoldState> key = GlobalKey();

class _HesabatviewState extends State<Hesabatview> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SupplierCubit(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => TransactionCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        key: key,
        drawer: MediaQuery.sizeOf(context).width < 600
            ? Customdrawer(drawerKey: drawerKey)
            : null,
        body: AdaptiveLayout(
            mobileLayout: (context) => const Hesbatmobilelayout(),
            tabletLayout: (context) => const Hesabatscaffold(),
            desktopLayout: (context) => const Hesabatscaffold()),
      ),
    );
  }
}

class Hesbatmobilelayout extends StatelessWidget {
  const Hesbatmobilelayout({super.key});

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
        const Expanded(child: Hesabatcontainer()),
      ],
    );
  }
}
