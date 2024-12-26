import 'package:aldafttar/features/Loginview/manager/signin/cubit/signin_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/drawercubit/cubit/drawer_cubit.dart';
import 'package:aldafttar/firebase_options.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/sizeconfig.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BindingBase.debugZoneErrorsAreFatal = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const Aldaftar(),
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
          create: (context) => SigninCubit(),
        ),
        BlocProvider(
          create: (context) => DrawerCubit(),
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
