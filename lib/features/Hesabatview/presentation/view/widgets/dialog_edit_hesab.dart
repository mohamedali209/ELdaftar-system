import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/transaction/cubit/transaction_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DialogEditHesab extends StatefulWidget {
  const DialogEditHesab({
    super.key,
    required this.ayar21Controller,
    required this.nakdyiaController,
    required this.hesabmodel,
  });

  final TextEditingController ayar21Controller;
  final TextEditingController nakdyiaController;
  final Hesabmodel hesabmodel;

  @override
  State<DialogEditHesab> createState() => _DialogEditHesabState();
}

class _DialogEditHesabState extends State<DialogEditHesab> {
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
                      controller: widget.ayar21Controller,
                      decoration: const InputDecoration(labelText: 'عيار 21'),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 10), // Space between fields
                    TextField(
                      controller: widget.nakdyiaController,
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
                  onPressed: () async {
                    final transactionCubit = context.read<TransactionCubit>();
                    final navigator = Navigator.of(context);

                    try {
                      // Wait until addTransaction finishes
                      await context.read<SupplierCubit>().addTransaction(
                            widget.hesabmodel.id,
                            widget.ayar21Controller.text,
                            widget.nakdyiaController.text,
                            true, // true indicates an addition
                          );

                      // Optional: Add a small delay to ensure the database update completes
                      await Future.delayed(const Duration(milliseconds: 200));

                      // Refetch the transactions after the addTransaction completes
                      await transactionCubit
                          .fetchTransactions(widget.hesabmodel.id);

                      if (mounted) {
                        navigator.pop(); // Close dialog
                      }
                    } catch (error) {
                      // Handle any errors in the process
                      print("Error adding transaction: $error");
                    }
                  },
                  child: Container(
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
                  onPressed: () async {
                    // Store references to the cubits and navigator
                    final transactionCubit = context.read<TransactionCubit>();
                    final navigator = Navigator.of(context);

                    try {
                      // Wait until addTransaction completes
                      await context.read<SupplierCubit>().addTransaction(
                            widget.hesabmodel.id,
                            widget.ayar21Controller.text,
                            widget.nakdyiaController.text,
                            false, // false indicates a subtraction
                          );

                      // Optional: Add a small delay to ensure the database update completes
                      await Future.delayed(const Duration(milliseconds: 200));

                      // Refetch the transactions after the addTransaction completes
                      await transactionCubit
                          .fetchTransactions(widget.hesabmodel.id);

                      // Close the dialog if still mounted
                      if (mounted) {
                        navigator.pop();
                      }
                    } catch (error) {
                      // Handle any errors in the process
                      print("Error during transaction subtraction: $error");
                    }
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
              context
                  .read<TransactionCubit>()
                  .fetchTransactions(widget.hesabmodel.id);
            },
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}
