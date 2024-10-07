import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:flutter/material.dart';

class SignTextfields extends StatelessWidget {
  const SignTextfields({
    super.key,
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
            controller: TextEditingController(),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField2(
            hintText: ' كلمة المرور',
            controller: TextEditingController(),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}