import 'package:aldafttar/features/Loginview/view/widgets/login_textfields.dart';
import 'package:aldafttar/features/Loginview/view/widgets/loginbutton.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Signinbody(),
    );
  }
}

class Signinbody extends StatelessWidget {
  const Signinbody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height, // Ensures the content takes up full height
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            children: [
              Text(
                'الدفتر',
                style: Appstyles.bold50(context).copyWith(fontSize: 70),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'تسجيل الدخول',
                style: Appstyles.regular25(context).copyWith(color: Colors.amber),
              ),
              const SignTextfields(),
              const Loginbutton(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      AppRouter.router.push(AppRouter.ksignupview);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Removes the padding
                    ),
                    child: Text(
                      'قم ب انشاء حساب',
                      style: Appstyles.regular12cairo(context)
                          .copyWith(fontSize: 12, color: Colors.amber),
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text('ليس لديك حساب ؟',
                      style: Appstyles.regular12cairo(context).copyWith(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
