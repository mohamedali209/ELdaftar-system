import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/sizeconfig.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Aldaftar());
}

class Aldaftar extends StatelessWidget {
  const Aldaftar({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
