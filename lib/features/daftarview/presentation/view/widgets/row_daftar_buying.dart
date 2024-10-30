import 'package:aldafttar/features/daftarview/presentation/view/manager/cubit/items_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/item_sellorbuy.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/modifying_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RowofdaftarBuyingItem extends StatelessWidget {
  const RowofdaftarBuyingItem({super.key, required this.daftarcheckmodel});
  final Daftarcheckmodel daftarcheckmodel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemSellorBuy(
            tfasel: daftarcheckmodel.tfasel,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(child: Text('تفاصيل')), // Dialog title
                    content: Center(
                        child: Text(
                      daftarcheckmodel.tfasel,
                    )), // Show tfasel content
                    actions: <Widget>[
                      TextButton(
                        child: const Text('إغلاق'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
            num: daftarcheckmodel.num,
            details: daftarcheckmodel.details,
            onTap: () {
              _showModifyOrDeleteDialog(context, daftarcheckmodel,
                  BlocProvider.of<ItemsCubit>(context));
            },
            ayar: daftarcheckmodel.ayar,
            adad: daftarcheckmodel.adad,
            price: daftarcheckmodel.price,
            gram: daftarcheckmodel.gram),
        const Divider(
          color: Color(0xff1D1D1D),
          thickness: 2,
        ),
      ],
    );
  }

  void _showModifyOrDeleteDialog(
      BuildContext context, Daftarcheckmodel item, ItemsCubit itemsCubit) {
    final TextEditingController adadController =
        TextEditingController(text: item.adad);
    final TextEditingController gramController =
        TextEditingController(text: item.gram);
    final TextEditingController priceController =
        TextEditingController(text: item.price);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModifyOrDeleteDialog(
          isBuyingItem: true,
          adadController: adadController,
          gramController: gramController,
          priceController: priceController,
          item: item,
          itemsCubit: itemsCubit,
        );
      },
    );
  }
}
