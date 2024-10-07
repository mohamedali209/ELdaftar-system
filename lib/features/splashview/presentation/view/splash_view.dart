import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashBody(),
    );
  }
}

class SplashBody extends StatefulWidget {
  const SplashBody({
    super.key,
  });

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  final colors = [
    Colors.white,
    const Color.fromARGB(255, 86, 207, 112),
    Colors.yellow,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    push();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/backkkk.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay with text animation
        Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          color: const Color(0x99151312), // Adding slight transparency to the overlay color
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'الدفتر',
                textStyle: Appstyles.bold50(context).copyWith(fontSize: 80),
                colors: colors,
              ),
            ],
            totalRepeatCount: 2,
          ),
        ),
      ],
    );
  }

  void push() {
    Future.delayed(
      const Duration(seconds: 3),
      () => GoRouter.of(context).go(AppRouter.kloginview),
    );
  }
}
