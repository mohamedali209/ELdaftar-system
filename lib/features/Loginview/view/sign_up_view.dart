import 'package:aldafttar/features/Loginview/view/widgets/signup_button.dart';
import 'package:aldafttar/features/Loginview/view/widgets/signup_textfields.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context)
                .size
                .height, // Ensures full screen height
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                Text(
                  'الدفتر',
                  style: Appstyles.bold50(context).copyWith(fontSize: 70),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'انشاء حساب',
                  style: Appstyles.regular25(context)
                      .copyWith(color: Colors.amber),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SignupTextfields(),
                const Signupbutton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
