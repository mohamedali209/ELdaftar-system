import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_cubit.dart';
import 'package:aldafttar/features/addemployee/manager/cubit/addemployee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeList extends StatelessWidget {
  final String shopId;

  const EmployeeList({
    super.key,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEmployeeCubit, AddEmployeecubitState>(
      builder: (context, state) {
        if (state is AddEmployeeLoading) {
          return const SizedBox(); // Loading indicator
        } else if (state is AddEmployeeError) {
          return Text('Error: ${state.message}'); // Error message
        } else if (state is AddEmployeeLoaded) {
          final employees = state.employees;

          if (employees.isEmpty) {
            return const Text('لا يوجد موظفين.'); // Message when no employees
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              final uid = employee['uid']; // Assuming uid is stored

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(employee['name'] ?? 'اسم غير متوفر'),
                  subtitle:
                      Text(employee['email'] ?? 'بريد إلكتروني غير متوفر'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context
                          .read<AddEmployeeCubit>()
                          .deleteEmployee(shopId, uid);
                      context.read<AddEmployeeCubit>().fetchEmployees(shopId);
                    },
                  ),
                ),
              );
            },
          );
        }

        return const Text('لا يوجد موظفين.');
      },
    );
  }
}
