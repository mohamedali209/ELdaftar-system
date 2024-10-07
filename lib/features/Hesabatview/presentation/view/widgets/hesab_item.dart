import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_state.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/supplierwazna_nkdyia.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/daftar_container_item.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Hesabitem extends StatelessWidget {
  const Hesabitem({
    super.key,
    required this.hesabmodel,
  });

  final Hesabmodel hesabmodel;

  void _showEditDialog(BuildContext context) {
    // Fetch transactions when the dialog opens
    context.read<SupplierCubit>().fetchTransactions(hesabmodel.id);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Center(child: Text('تعديل الحساب')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DaftarcontainerItem(
                        title: 'جرام 18',
                      ),
                      DaftarcontainerItem(
                        title: 'جرام 21',
                      ),
                      DaftarcontainerItem(
                        title: 'جرام 24',
                      ),
                      DaftarcontainerItem(
                        title: 'نقدية',
                      ),
                      DaftarcontainerItem(
                        title: 'التاريخ',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<SupplierCubit, SupplierState>(
                    builder: (context, state) {
                      if (state is SupplierTransactionsLoadSuccess) {
                        final transactions = state.transactions;

                        return SizedBox(
                          height: 400,
                          width: 950,
                          child: ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];

                              // Determine color based on whether it's an addition or subtraction
                              final color = transaction.isAddition
                                  ? Colors.green
                                  : Colors.red;

                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DaftarcontainerItem(
                                      color: color,
                                      title: transaction.wazna18.toString(),
                                    ),
                                    DaftarcontainerItem(
                                      color: color,
                                      title: transaction.wazna21.toString(),
                                    ),
                                    DaftarcontainerItem(
                                      color: color,
                                      title: transaction.wazna24.toString(),
                                    ),
                                    DaftarcontainerItem(
                                      color: color,
                                      title: transaction.nakdyia.toString(),
                                    ),
                                    DaftarcontainerItem(
                                      color: color,
                                      title: transaction.date.toString(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }

                      if (state is SupplierLoadInProgress) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return const Center(
                          child: Text('No transactions available'));
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog without changes
                    context
                        .read<SupplierCubit>()
                        .fetchSuppliers(); // Reload suppliers
                  },
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    _showTransactionDialog(
                        context); // Open the transaction dialog
                    context
                        .read<SupplierCubit>()
                        .fetchSuppliers(); // Reload suppliers
                  },
                  child: const Text('تعديل'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTransactionDialog(BuildContext context) {
    final TextEditingController ayar18Controller = TextEditingController();
    final TextEditingController ayar21Controller = TextEditingController();
    final TextEditingController ayar24Controller = TextEditingController();
    final TextEditingController nakdyiaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('تعديل القيم')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ayar18Controller,
                decoration: const InputDecoration(labelText: 'عيار 18'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ayar21Controller,
                decoration: const InputDecoration(labelText: 'عيار 21'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ayar24Controller,
                decoration: const InputDecoration(labelText: 'عيار 24'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: nakdyiaController,
                decoration: const InputDecoration(labelText: 'نقدية'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
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
                  child: const Text('إضافة'),
                ),
                TextButton(
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
                  child: const Text('طرح'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without changes
                context.read<SupplierCubit>().fetchTransactions(hesabmodel.id);
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color(0xff151312),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _showEditDialog(context); // Open the edit dialog
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<SupplierCubit>().deleteSupplier(hesabmodel.id);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              hesabmodel.suppliername,
              style: Appstyles.regular25(context).copyWith(fontSize: 30),
            ),
          ),
          const Divider(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Supplierwaznaornkdyia(
                  waznaornakdyia: '18 وزنة',
                  num: hesabmodel.wazna18,
                ),
                Supplierwaznaornkdyia(
                  waznaornakdyia: '21 وزنة',
                  num: hesabmodel.wazna21,
                ),
                Supplierwaznaornkdyia(
                  waznaornakdyia: '24 وزنة',
                  num: hesabmodel.wazna24,
                ),
                Supplierwaznaornkdyia(
                  waznaornakdyia: 'نقدية',
                  num: hesabmodel.nakdyia,
                ),
                Supplierwaznaornkdyia(
                  waznaornakdyia: 'اجمالي الوزنة 21',
                  num: hesabmodel.total21.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
