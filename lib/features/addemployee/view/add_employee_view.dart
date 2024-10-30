import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_cubit.dart';
import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_state.dart';
import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'موظف'; // Default role selection

  @override
  Widget build(BuildContext context) {
    // Get the current authenticated user's ID
    final String shopId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('اضافة موظف', style: Appstyles.bold50(context)),
            const SizedBox(height: 50),
            CustomTextField2(
                controller: nameController, hintText: 'اسم الموظف'),
            const SizedBox(height: 25),
            CustomTextField2(
                controller: emailController, hintText: 'البريد الالكتروني'),
            const SizedBox(height: 25),
            CustomTextField2(
              obscureText: true,
              controller: passwordController,
              hintText: 'كلمة المرور',
            ),
            const SizedBox(height: 25),

            // Dropdown for selecting the role
            DropdownButton<String>(
              value: selectedRole,
              items: ['موظف', 'مدير'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child:
                      Text(role, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (newRole) {
                setState(() {
                  selectedRole = newRole!;
                });
              },
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 25),
            BlocConsumer<AddEmployeeCubit, AddEmployeeState>(
              listener: (context, state) {
                if (state is AddEmployeeSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('موظف تمت اضافته بنجاح')),
                  );

                  // Clear the text fields and reset the role selection
                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  setState(() {
                    selectedRole = 'موظف'; // Reset to default
                  });
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
                          context.read<AddEmployeeCubit>().addEmployee(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                shopId: shopId,
                                role: selectedRole, // Pass the selected role
                              );
                        },
                  child: state is AddEmployeeLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('اضافة'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
