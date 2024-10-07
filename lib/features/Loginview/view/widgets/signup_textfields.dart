import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:flutter/material.dart';

class SignupTextfields extends StatelessWidget {
  const SignupTextfields({
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
              controller: TextEditingController(),
              hintText: 'البريد الالكتروني'),
          const SizedBox(
            height: 20,
          ),
          CustomTextField2(
              controller: TextEditingController(),
              hintText: 'كلمة المرور'),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField2(
                    controller: TextEditingController(),
                    hintText: 'الاسم'),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CustomTextField2(
                    controller: TextEditingController(),
                    hintText: 'اسم المحل'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextField2(
              keyboardType: TextInputType.number,
              controller: TextEditingController(),
              hintText: 'رقم الموبايل'),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
