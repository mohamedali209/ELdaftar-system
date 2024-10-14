import 'package:flutter/material.dart';
import 'package:aldafttar/utils/custom_textfields.dart';

class SignupTextfields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController storeNameController;
  final TextEditingController phoneController;

  const SignupTextfields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.storeNameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .1),
      child: Column(
        children: [
          CustomTextField2(
              controller: emailController,
              hintText: 'البريد الالكتروني'),
          const SizedBox(height: 20),
          CustomTextField2(
              controller: passwordController,
              hintText: 'كلمة المرور'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomTextField2(
                  controller: nameController,
                  hintText: 'الاسم',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextField2(
                  controller: storeNameController,
                  hintText: 'اسم المحل',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTextField2(
              keyboardType: TextInputType.number,
              controller: phoneController,
              hintText: 'رقم الموبايل'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
