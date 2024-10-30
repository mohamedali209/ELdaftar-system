import 'package:aldafttar/features/daftarview/presentation/view/manager/cubit/items_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:flutter/material.dart';

class ModifyOrDeleteDialog extends StatefulWidget {
  final TextEditingController adadController;
  final TextEditingController gramController;
  final TextEditingController priceController;
  final Daftarcheckmodel item;
  final ItemsCubit itemsCubit;
  final bool isBuyingItem; // Add this final field

  const ModifyOrDeleteDialog({
    super.key,
    required this.adadController,
    required this.gramController,
    required this.priceController,
    required this.item,
    required this.itemsCubit,
    required this.isBuyingItem, // Pass isBuyingItem
  });

  @override
  ModifyOrDeleteDialogState createState() => ModifyOrDeleteDialogState();
}

class ModifyOrDeleteDialogState extends State<ModifyOrDeleteDialog> {
  late String selectedAyar;

  @override
  void initState() {
    super.initState();
    // Initialize selectedAyar with the value from the item
    selectedAyar = widget.item.ayar;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 12, 12, 12),
        title: Center(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Color(0xff594300), Colors.amber],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ).createShader(bounds);
            },
            child: const Text(
              'تعديل او حذف',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
        content: Container(
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Colors.black,
                Color.fromARGB(255, 44, 33, 3),
              ],
              stops: [0.80, 1.0],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.adadController,
                decoration: const InputDecoration(labelText: "عدد"),
              ),
              TextField(
                controller: widget.gramController,
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
                  setState(() {
                    selectedAyar = newValue!;
                  });
                },
              ),
              TextField(
                controller: widget.priceController,
                decoration: const InputDecoration(labelText: "السعر"),
              ),
            ],
          ),
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
                    Navigator.of(context).pop();
                  },
                  child: const Text('إلغاء'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Modify the item
                    final modifiedItem = widget.item.copyWith(
                      adad: widget.adadController.text,
                      gram: widget.gramController.text,
                      ayar: selectedAyar,
                      price: widget.priceController.text,
                    );
                    widget.itemsCubit.modifyItem(modifiedItem, isBuyingItem: widget.isBuyingItem); // Use isBuyingItem
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff735600), Colors.amber],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(15),
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
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 23, 8),
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    widget.itemsCubit.deleteItem(widget.item);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'مسح',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
