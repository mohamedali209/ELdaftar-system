import 'package:aldafttar/features/Gardview/presentation/view/Gardview.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/hesabat_view.dart';
import 'package:aldafttar/features/daftarview/presentation/view/desktop_layout.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/tahlel_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kDaftarview = '/';
  static const kgardview = '/gardView';
  static const khesabatview = '/hesabatview';
  static const ktahlelView = '/tahlelView';
  static final router = GoRouter(
    routes: [
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
        path: ktahlelView,
        builder: (context, state) => const Tahlelview(),
      ),
    ],
  );
}
