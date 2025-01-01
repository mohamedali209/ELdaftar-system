import 'package:aldafttar/features/daftarview/presentation/view/manager/expensescubit/cubit/expenses_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/expensescubit/cubit/expenses_state.dart';
import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseModalSheet extends StatefulWidget {
  const ExpenseModalSheet({super.key});

  @override
  ExpenseModalSheetState createState() => ExpenseModalSheetState();
}

class ExpenseModalSheetState extends State<ExpenseModalSheet> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  late String year;
  late String month;
  late String day;

  @override
  void initState() {
    super.initState();

    // Fetch expenses when the modal sheet is opened
    final expensesCubit = BlocProvider.of<ExpensesCubit>(context);

    // Initialize date values for fetchExpenses
    year = DateTime.now().year.toString();
    month = DateTime.now().month.toString().padLeft(2, '0');
    day = DateTime.now().day.toString().padLeft(2, '0');

    expensesCubit.fetchExpenses(
      year: year,
      month: month,
      day: day,
    );
  }

  void _addExpense() {
    String description = _descriptionController.text;
    String amountStr = _amountController.text;

    if (description.isNotEmpty && amountStr.isNotEmpty) {
      int? amount = int.tryParse(amountStr);
      if (amount != null) {
        BlocProvider.of<ExpensesCubit>(context).addExpense(
          year: year,
          month: month,
          day: day,
          description: description,
          amount: amount,
        );

        // Clear input fields after adding
        _descriptionController.clear();
        _amountController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // Adjust padding when keyboard is visible
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Color(0xff594300), Colors.amber],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'المصاريف اليومية',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField2(
                  controller: _descriptionController,
                  hintText: 'الوصف',
                ),
                const SizedBox(height: 16),
                CustomTextField2(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow digits only
                  ],
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  hintText: 'المبلغ',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addExpense,
                  child: const Text('حفظ',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ExpensesCubit, ExpensesState>(
                  builder: (context, state) {
                    if (state is ExpensesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ExpensesLoaded) {
                      final expenses = state.expenses;
                      return expenses.isEmpty
                          ? const Text('لا توجد مصاريف حتى الآن.')
                          : ListView.builder(
                              shrinkWrap:
                                  true, // Prevent ListView from taking infinite height
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable scroll within the ListView
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final expense = expenses[index];
                                return ListTile(
                                  title: Text(expense.description),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${expense.amount} ج'),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          BlocProvider.of<ExpensesCubit>(
                                                  context)
                                              .deleteExpense(
                                            year: year,
                                            month: month,
                                            day: day,
                                            description: expense.description,
                                            amount: expense.amount,
                                          );
                                          BlocProvider.of<ExpensesCubit>(
                                                  context)
                                              .fetchExpenses(
                                            year: year,
                                            month: month,
                                            day: day,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                    } else if (state is ExpensesError) {
                      return Text('Error: ${state.message}');
                    } else {
                      return const Text('Unknown state.');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
