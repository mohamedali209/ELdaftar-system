import 'package:aldafttar/features/CollectionEldafaterview/manager/cubit/collectiondfater_cubit.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/eldafater_view.dart';
import 'package:aldafttar/features/Gardview/presentation/view/gardview.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/hesabat_view.dart';
import 'package:aldafttar/features/Loginview/manager/employeelogin/cubit/employee_cubit.dart';
import 'package:aldafttar/features/Loginview/view/sign_up_view.dart';
import 'package:aldafttar/features/Loginview/view/signinview.dart';
import 'package:aldafttar/features/Loginview/view/widgets/employee_login_screen.dart';
import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_cubit.dart';
import 'package:aldafttar/features/addemployee/view/add_employee_view.dart';
import 'package:aldafttar/features/daftarview/presentation/view/desktop_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/cubit/items_cubit.dart';
import 'package:aldafttar/features/employeesdftar/manager/cubit/employeesitem_cubit.dart';
import 'package:aldafttar/features/employeesdftar/view/employees_dftar_screen.dart';
import 'package:aldafttar/features/inventoryscreen/presentation/view/inventory_screen.dart';
import 'package:aldafttar/features/marmatview/view/marmat_view.dart';
import 'package:aldafttar/features/splashview/presentation/view/splash_view.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/tahlel_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const ksplashview = '/';
  static const ksignupview = '/signupview';
  static const kloginview = '/loginview';

  static const kinventoryview = '/InventoryView';
  static const kDaftarview = '/DaftarView';

  static const kgardview = '/gardView';
  static const khesabatview = '/hesabatview';
  static const kmarmatview = '/marmatview';
  static const ktahlelView = '/tahlelView';
  static const kcollectiondafterView = '/collectiondafterView';
  static const kaddemployee = '/addemployee';
  static const kemployeelogin = '/employeeLogin';

  static const kemployeeDaftar = '/employeeDaftar';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: ksplashview,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: kloginview,
        builder: (context, state) => const SigninScreen(),
      ),
      GoRoute(
        path: ksignupview,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: kinventoryview,
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: kDaftarview,
        builder: (context, state) => const Daftarview(),
      ),
      GoRoute(
        path: kgardview,
        builder: (context, state) => const Gardfawryview(),
      ),
      GoRoute(
        path: khesabatview,
        builder: (context, state) => const Hesabatview(),
      ),
      GoRoute(
        path: kmarmatview,
        builder: (context, state) => const MarmatScreen(),
      ),
      GoRoute(
        path: ktahlelView,
        builder: (context, state) => const Tahlelview(),
      ),
      GoRoute(
        path: kcollectiondafterView,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  CollectiondfaterCubit(FirebaseFirestore.instance),
            ),
            BlocProvider(
              create: (context) => ItemsCubit(),
            ),
          ],
          child: const Eldafaterview(),
        ),
      ),
      GoRoute(
        path: kaddemployee,
        builder: (context, state) => BlocProvider(
          create: (context) => AddEmployeeCubit(),
          child: const AddEmployee(),
        ),
      ),
      GoRoute(
        path: kemployeelogin,
        builder: (context, state) => BlocProvider(
          create: (context) => EmployeeCubit(),
          child: const EmployeeLoginScreen(),
        ),
      ),
      GoRoute(
        path: kemployeeDaftar,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ItemsCubit(),
            ),
            BlocProvider(
              create: (context) => EmployeesitemCubit(),
            ),
          ],
          child: const EmployeesDaftarScreen(),
        ),
      ),
    ],
  );
}
