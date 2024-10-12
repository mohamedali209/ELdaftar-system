import 'package:aldafttar/features/Gardview/presentation/view/Gardview.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/hesabat_view.dart';
import 'package:aldafttar/features/Loginview/view/signinview.dart';
import 'package:aldafttar/features/Loginview/view/sign_up_view.dart';
import 'package:aldafttar/features/daftarview/presentation/view/desktop_layout.dart';
import 'package:aldafttar/features/inventoryscreen/presentation/view/inventory_screen.dart';
import 'package:aldafttar/features/marmatview/view/marmat_view.dart';
import 'package:aldafttar/features/splashview/presentation/view/splash_view.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/tahlel_view.dart';
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
    ],
  );
}
