import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_cubit.dart';
import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_state.dart';
import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddEmployee extends StatelessWidget {
  const AddEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const SizedBox(height: 50),
          Text('اضافة موظف', style: Appstyles.bold50(context)),
          const SizedBox(height: 50),
          CustomTextField2(controller: nameController, hintText: 'اسم الموظف'),
          const SizedBox(height: 25),
          CustomTextField2(
              controller: emailController, hintText: 'البريد الالكتروني'),
          const SizedBox(height: 25),
          CustomTextField2(
              controller: passwordController, hintText: 'كلمة المرور'),
          const SizedBox(height: 25),
          BlocConsumer<AddEmployeeCubit, AddEmployeeState>(
            listener: (context, state) {
              if (state is AddEmployeeSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('موظف تمت اضافته بنجاح')),
                );

                // Clear the text fields after successful addition
                nameController.clear();
                emailController.clear();
                passwordController.clear();
              } else if (state is AddEmployeeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is AddEmployeeLoading
                    ? null
                    : () {
                        final cubit =
                            BlocProvider.of<AddEmployeeCubit>(context);
                        cubit.addEmployee(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                child: state is AddEmployeeLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('اضافة'),
              );
            },
          ),
        ]),
      ),
    );
  }
}
