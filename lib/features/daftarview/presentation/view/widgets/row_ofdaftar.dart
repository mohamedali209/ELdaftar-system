import 'package:aldafttar/features/daftarview/presentation/view/manager/cubit/items_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/item_sellorBuy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Rowofdaftar extends StatelessWidget {
  const Rowofdaftar({super.key, required this.daftarcheckmodel});
  final Daftarcheckmodel daftarcheckmodel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemSellorBuy(
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
    String selectedAyar = item.ayar;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تعديل او حذف"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: adadController,
                decoration: const InputDecoration(labelText: "عدد"),
              ),
              TextField(
                controller: gramController,
                decoration: const InputDecoration(labelText: "وزن"),
              ),
              DropdownButtonFormField<String>(
                value: selectedAyar,
                decoration: const InputDecoration(labelText: "عيار"),
                items: ['18k', '21k', '24k']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedAyar = newValue!;
                },
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "السعر"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("الغاء"),
            ),
            TextButton(
              onPressed: () {
                // Modify the item
                final modifiedItem = item.copyWith(
                  adad: adadController.text,
                  gram: gramController.text,
                  ayar: selectedAyar,
                  price: priceController.text,
                );
                itemsCubit.modifyItem(modifiedItem, isBuyingItem: false);
                Navigator.of(context).pop();
              },
              child: const Text("تعديل",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.amber)),
            ),
            TextButton(
              onPressed: () {
                // Delete the item
                itemsCubit.deleteItem(item);
                Navigator.of(context).pop();
              },
              child: const Text("مسح",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
