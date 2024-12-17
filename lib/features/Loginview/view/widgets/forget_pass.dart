import 'package:aldafttar/features/Loginview/view/widgets/loginbutton.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetpassScreen extends StatelessWidget {
  ForgetpassScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  void resetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال البريد الإلكتروني')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'),
          backgroundColor: Colors.green,
        ),
      );
      AppRouter.router.go(AppRouter.kloginview); // Navigate back to login
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'المستخدم غير موجود';
            break;
          case 'invalid-email':
            errorMessage = 'البريد الإلكتروني غير صالح';
            break;
          default:
            errorMessage = 'حدث خطأ. حاول مرة أخرى';
        }
      } else {
        errorMessage = 'حدث خطأ غير متوقع';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Centered content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'الدفتر',
                      style: Appstyles.bold50(context).copyWith(fontSize: 70),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'نسيت كلمة المرور',
                      style: Appstyles.regular25(context)
                          .copyWith(color: Colors.amber),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          CustomTextField2(
                            
                            controller: emailController,
                            hintText: 'البريد الالكتروني',
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Loginbutton(
                      onPressed: () => resetPassword(context),
                      text: 'إعادة تعيين كلمة المرور',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Back button at the top left
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.amber),
              onPressed: () {
                AppRouter.router.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
