import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:flutter/material.dart';

class SignTextfields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignTextfields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .1),
      child: Column(
        children: [
          CustomTextField2(
            hintText: 'البريد الالكتروني',
            controller: emailController,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField2(
            obscureText: true,
            hintText: 'كلمة المرور',
            controller: passwordController,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
