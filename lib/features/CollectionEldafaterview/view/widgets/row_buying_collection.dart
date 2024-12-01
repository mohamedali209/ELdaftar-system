import 'package:aldafttar/features/CollectionEldafaterview/manager/modify/cubit/collection_modify_cubit.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/collection_dialog.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/item_sellorbuy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CollectionRowofdaftarBuyingItem extends StatelessWidget {
  const CollectionRowofdaftarBuyingItem(
      {super.key, required this.daftarcheckmodel});
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
                    title: const Center(child: Text('تفاصيل')),
                    content: Center(child: Text(daftarcheckmodel.tfasel)),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('إغلاق'),
                        onPressed: () {
                          Navigator.of(context).pop();
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
              _showCollectionModifyOrDeleteDialog(
                context,
                daftarcheckmodel,
                BlocProvider.of<CollectionModifyCubit>(context),
              );
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

  void _showCollectionModifyOrDeleteDialog(
    BuildContext context,
    Daftarcheckmodel item,
    CollectionModifyCubit itemsCubit,
  ) {
    final TextEditingController adadController =
        TextEditingController(text: item.adad);
    final TextEditingController gramController =
        TextEditingController(text: item.gram);
    final TextEditingController priceController =
        TextEditingController(text: item.price);

    final DateTime? selectedDate = itemsCubit.selectedDate;

    if (selectedDate == null) {
      debugPrint('No date selected. Please select a date first.');
      return;
    }

    final String year = DateFormat('yyyy').format(selectedDate);
    final String month = DateFormat('MM').format(selectedDate);
    final String day = DateFormat('dd').format(selectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CollectionModifyOrDeleteDialog(
          day: day,
          month: month,
          year: year,
          isBuyingItem: true,
          collectionModifyCubit: itemsCubit,
          adadController: adadController,
          gramController: gramController,
          priceController: priceController,
          item: item,
        );
      },
    );
  }
}
