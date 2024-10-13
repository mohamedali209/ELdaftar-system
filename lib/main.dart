import 'package:aldafttar/features/Gardview/presentation/manager/cubit/updateinventory/cubit/updateinventory_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/drawercubit/cubit/drawer_cubit.dart';
import 'package:aldafttar/features/marmatview/manager/cubit/marmat_cubit.dart';
import 'package:aldafttar/firebase_options.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/sizeconfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const Aldaftar(),
    ),
  );
}

class Aldaftar extends StatelessWidget {
  const Aldaftar({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DrawerCubit(),
        ),
        BlocProvider(
          create: (context) => SupplierCubit(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => UpdateInventoryCubit(),
        ),
        BlocProvider(
          create: (context) =>
              MarmatCubit(firestore: FirebaseFirestore.instance),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
