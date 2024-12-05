import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_cubit.dart';
import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_state.dart';
import 'package:aldafttar/features/addemployee/view/widgets/employee_list.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  AddEmployeeState createState() => AddEmployeeState();
}

class AddEmployeeState extends State<AddEmployee> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'موظف';

  @override
  void initState() {
    super.initState();
    final shopId = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<AddEmployeeCubit>().fetchEmployees(shopId);
  }

  @override
  Widget build(BuildContext context) {
    final String shopId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppRouter.router.go(AppRouter.kDaftarview);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text('اضافة موظف', style: Appstyles.bold50(context)),
              const SizedBox(height: 50),
              CustomTextField2(
                controller: nameController,
                hintText: 'اسم الموظف',
              ),
              const SizedBox(height: 25),
              CustomTextField2(
                controller: emailController,
                hintText: 'البريد الالكتروني',
              ),
              const SizedBox(height: 25),
              CustomTextField2(
                obscureText: true,
                controller: passwordController,
                hintText: 'كلمة المرور',
              ),
              const SizedBox(height: 25),
              BlocConsumer<AddEmployeeCubit, AddEmployeecubitState>(
                listener: (context, state) {
                  if (state is AddEmployeeSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        
                        content: Text('تم الضافةاو الحذف بنجاح قم بتسجيل حسابك مجددا'),
                      ),
                    );

                    Future.delayed(const Duration(seconds: 2), () async {
                      await FirebaseAuth.instance.signOut();
                      AppRouter.router.go(AppRouter.kloginview);
                    });
                  } else if (state is AddEmployeeError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: state is AddEmployeeLoading
                        ? null
                        : () async {
                            await context.read<AddEmployeeCubit>().addEmployee(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  shopId: shopId,
                                  role: selectedRole,
                                );
                          },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .04,
                      width: MediaQuery.of(context).size.width * .4,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.amber,
                            Color(0xFFBF8F00),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: state is AddEmployeeLoading
                            ? const CustomLoadingIndicator()
                            : Text(
                                'اضافة',
                                style: Appstyles.regular25(context),
                              ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Use EmployeeList widget here
              EmployeeList(shopId: shopId),
            ],
          ),
        ),
      ),
    );
  }
}
