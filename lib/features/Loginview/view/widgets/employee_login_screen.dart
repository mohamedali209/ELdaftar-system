import 'package:aldafttar/features/Loginview/manager/employeelogin/cubit/employee_cubit.dart';
import 'package:aldafttar/features/Loginview/view/widgets/loginbutton.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmployeeLoginScreen extends StatelessWidget {
  const EmployeeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<EmployeeCubit, String?>(
      // Use a BlocListener to handle login state
      listener: (context, state) {
        if (state == null) {
          // Show loading spinner
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CustomLoadingIndicator()),
          );
        } else if (state == "مدير" || state == "موظف") {
          Navigator.of(context).pop(); // Close the loading dialog
          GoRouter.of(context).go(AppRouter.kemployeeDaftar);
        } else {
          // Close loading dialog if open
          Navigator.of(context).pop();
          // Show error message using ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
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
                    'تسجيل الدخول كموظف',
                    style: Appstyles.regular25(context)
                        .copyWith(color: Colors.amber),
                  ),
                  // Text fields for email and password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              labelText: 'البريد الإلكتروني'),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration:
                              const InputDecoration(labelText: 'كلمة المرور'),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Loginbutton(
                    onPressed: () {
                       context.read<EmployeeCubit>().loginEmployee(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
