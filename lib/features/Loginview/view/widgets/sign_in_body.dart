import 'package:aldafttar/features/Loginview/manager/signin/cubit/signin_cubit.dart';
import 'package:aldafttar/features/Loginview/manager/signin/cubit/signin_state.dart';
import 'package:aldafttar/features/Loginview/view/widgets/login_textfields.dart';
import 'package:aldafttar/features/Loginview/view/widgets/loginbutton.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Signinbody extends StatelessWidget {
  const Signinbody({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state.isLoading) {
          // Show loading spinner
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CustomLoadingIndicator()),
          );
        } else if (state.isSuccess) {
          Navigator.of(context).pop(); // Close the loading dialog
          GoRouter.of(context).go(AppRouter.kDaftarview);
        } else if (state.errorMessage != null) {
          // Close loading dialog if open
          Navigator.of(context).pop();
          // Show error message using ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: SingleChildScrollView(
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
                  'تسجيل الدخول',
                  style: Appstyles.regular25(context)
                      .copyWith(color: Colors.amber),
                ),
                SignTextfields(
                  emailController: emailController,
                  passwordController: passwordController,
                ),
                const SizedBox(height: 20),
                Loginbutton(
                  onPressed: () {
                    // Trigger sign-in when the button is pressed
                    BlocProvider.of<SigninCubit>(context).signin(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    AppRouter.router.push(AppRouter.kinventoryview);
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            AppRouter.router.push(AppRouter.ksignupview);
                          },
                          child: Text(
                            ' قم ب انشاء حساب',
                            style: Appstyles.regular12cairo(context).copyWith(
                              fontSize: 12,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        Text(
                          ' ليس لديك حساب ؟',
                          style: Appstyles.regular12cairo(context)
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const Text('او'),
                    TextButton(
                        onPressed: () {
                          AppRouter.router.push(AppRouter.kemployeelogin);
                        },
                        child: Text('تسجيل الدخول كموظف',
                            style: Appstyles.regular12cairo(context).copyWith(
                              fontSize: 14,
                              color: Colors.amber,
                            )))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
