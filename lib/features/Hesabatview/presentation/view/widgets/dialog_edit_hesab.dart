import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogEditHesab extends StatelessWidget {
  const DialogEditHesab({
    super.key,
    required this.ayar18Controller,
    required this.ayar21Controller,
    required this.ayar24Controller,
    required this.nakdyiaController,
    required this.hesabmodel,
  });

  final TextEditingController ayar18Controller;
  final TextEditingController ayar21Controller;
  final TextEditingController ayar24Controller;
  final TextEditingController nakdyiaController;
  final Hesabmodel hesabmodel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 12, 12, 12),
        title: Stack(
          children: [
            Center(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Color(0xff594300), Colors.amber],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ).createShader(bounds);
                },
                child: const Text(
                  'زيادة او خصم',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        content: Stack(
          children: [
            Container(
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    Colors.black, // First color
                    Color.fromARGB(255, 44, 33, 3), // Second color
                  ],
                  stops: [
                    0.80,
                    1.0
                  ], // Adjusts where each color starts and ends
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: ayar18Controller,
                      decoration: const InputDecoration(labelText: 'عيار 18'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10), // Space between fields
                    TextField(
                      controller: ayar21Controller,
                      decoration: const InputDecoration(labelText: 'عيار 21'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10), // Space between fields
                    TextField(
                      controller: ayar24Controller,
                      decoration: const InputDecoration(labelText: 'عيار 24'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10), // Space between fields
                    TextField(
                      controller: nakdyiaController,
                      decoration: const InputDecoration(labelText: 'نقدية'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    // Add the entered values to the current values
                    context.read<SupplierCubit>().addTransaction(
                          hesabmodel.id,
                          ayar18Controller.text,
                          ayar21Controller.text,
                          ayar24Controller.text,
                          nakdyiaController.text,
                          true, // true indicates an addition
                        );
                    Navigator.of(context).pop(); // Close dialog
                    context
                        .read<SupplierCubit>()
                        .fetchTransactions(hesabmodel.id);
                  },
                  child:Container(
                      width: 130,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff735600), Colors.amber],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                        borderRadius:
                            BorderRadius.circular(15), // Adjust as needed
                      ),
                      child: const Center(
                        child: Text(
                          'اضافة',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ),
              ),
              const SizedBox(width: 16), // Add space between buttons
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 152, 2, 2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    // Subtract the entered values from the current values
                    context.read<SupplierCubit>().addTransaction(
                          hesabmodel.id,
                          ayar18Controller.text,
                          ayar21Controller.text,
                          ayar24Controller.text,
                          nakdyiaController.text,
                          false, // false indicates a subtraction
                        );
                    Navigator.of(context).pop(); // Close dialog
                    context
                        .read<SupplierCubit>()
                        .fetchTransactions(hesabmodel.id);
                  },
                  child: const Text('خصم'),
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog without changes
              context.read<SupplierCubit>().fetchTransactions(hesabmodel.id);
            },
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}