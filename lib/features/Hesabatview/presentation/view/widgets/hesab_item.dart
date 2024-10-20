import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_state.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/dialog_edit_hesab.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/supplierwazna_nkdyia.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/daftar_container_item.dart';
import 'package:aldafttar/utils/custom_loading.dart';
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
                      child: Text(
                        'تعديل الحساب',
                        style: Appstyles.daftartodayheader(context).copyWith(
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
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DaftarcontainerItem(title: 'جرام 18'),
                            DaftarcontainerItem(title: 'جرام 21'),
                            DaftarcontainerItem(title: 'جرام 24'),
                            DaftarcontainerItem(title: 'نقدية'),
                            DaftarcontainerItem(title: 'التاريخ'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<SupplierCubit, SupplierState>(
                          builder: (context, state) {
                            if (state is SupplierTransactionsLoadSuccess) {
                              final transactions = state.transactions;

                              return SizedBox(
                                height: MediaQuery.of(context).size.height * .4,
                                width: MediaQuery.of(context).size.width * .9,
                                child: ListView.builder(
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = transactions[index];

                                    // Determine color based on whether it's an addition or subtraction
                                    final color = transaction.isAddition
                                        ? Colors.green
                                        : Colors.red;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DaftarcontainerItem(
                                            color: color,
                                            title:
                                                transaction.wazna18.toString(),
                                          ),
                                          DaftarcontainerItem(
                                            color: color,
                                            title:
                                                transaction.wazna21.toString(),
                                          ),
                                          DaftarcontainerItem(
                                            color: color,
                                            title:
                                                transaction.wazna24.toString(),
                                          ),
                                          DaftarcontainerItem(
                                            color: color,
                                            title:
                                                transaction.nakdyia.toString(),
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
                              return const Center(
                                  child: CustomLoadingIndicator());
                            }

                            return const Center(
                                child: Text('لا توجد معاملات متاحة'));
                          },
                        ),
                      ],
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
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Close dialog without changes
                          context
                              .read<SupplierCubit>()
                              .fetchSuppliers(); // Reload suppliers
                        },
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 16), // Add space between buttons
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          _showTransactionDialog(
                              context); // Open the transaction dialog
                          context
                              .read<SupplierCubit>()
                              .fetchSuppliers(); // Reload suppliers
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
                              'تعديل',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
        return DialogEditHesab(
            ayar18Controller: ayar18Controller,
            ayar21Controller: ayar21Controller,
            ayar24Controller: ayar24Controller,
            nakdyiaController: nakdyiaController,
            hesabmodel: hesabmodel);
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
