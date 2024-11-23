import 'package:aldafttar/features/Loginview/manager/employeelogin/cubit/employee_cubit.dart';
import 'package:aldafttar/features/Loginview/manager/employeelogin/cubit/employee_state.dart';
import 'package:aldafttar/features/Loginview/view/widgets/loginbutton.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({super.key});

  @override
  EmployeeLoginScreenState createState() => EmployeeLoginScreenState();
}

class EmployeeLoginScreenState extends State<EmployeeLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
  listener: (context, state) {
    if (state is EmployeeLoading) {
      // Show loading spinner
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CustomLoadingIndicator()),
      );
    } else {
      Navigator.of(context).pop(); // Close any open dialogs
      if (state is EmployeeSuccess) {
        GoRouter.of(context).go(AppRouter.kemployeeDaftar); // Navigate on success
      } else if (state is EmployeeFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage)),
        );
      }
    }
  },
      child: Scaffold(
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
                        'تسجيل الدخول كموظف',
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
                            CustomTextField2(
                              controller: passwordController,
                              hintText: 'كلمة المرور',
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
                  AppRouter.router.go(AppRouter.kloginview);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
