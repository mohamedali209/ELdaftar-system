import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSupplierDialog extends StatefulWidget {
  const AddSupplierDialog({super.key});

  @override
  AddSupplierDialogState createState() => AddSupplierDialogState();
}

class AddSupplierDialogState extends State<AddSupplierDialog> {
  String supplierName = '';
  String wazna21 = '';
  String nakdyia = '';

  // Helper method for building text fields
  Widget _buildTextField(
      String label, Function(String) onChanged, TextInputType? keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Text(
                'اضافة حساب',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
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
                  _buildTextField('الاسم', (value) => supplierName = value,
                      TextInputType.text),
                  const SizedBox(height: 5),
                  _buildTextField('وزنة 21', (value) => wazna21 = value,
                      TextInputType.number),
                  const SizedBox(height: 5),
                  _buildTextField('نقدية', (value) => nakdyia = value,
                      TextInputType.number),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/edafethesab.png',
                width: 200,
                height: 60,
                fit: BoxFit.cover,
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
            const SizedBox(width: 16),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  // Ensure supplierName is filled
                  if (supplierName.isNotEmpty) {
                    // Validate numeric input

                    double? wazna210 =
                        double.tryParse(wazna21.isNotEmpty ? wazna21 : '0');

                    double? nakdyia0 =
                        double.tryParse(nakdyia.isNotEmpty ? nakdyia : '0');

                    // Check if parsing failed (i.e., not valid numbers)
                    if (wazna210 == null || nakdyia0 == null) {
                      // Show an error message if any input is invalid
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('يرجى إدخال أرقام صحيحة فقط')),
                      );
                      return; // Exit early if any input is invalid
                    }

                    // Create the new supplier
                    final newSupplier = Hesabmodel(
                      transactions: [],
                      id: '', // Ensure this matches how you initialize the ID
                      suppliername: supplierName,
                      wazna21: wazna210.toString(),
                      nakdyia: nakdyia0.toString(),
                    );

                    // Add the supplier using the SupplierCubit
                    context.read<SupplierCubit>().addSupplier(newSupplier);

                    // Close the dialog
                    Navigator.of(context).pop();
                  } else {
                    // Show a SnackBar if the supplier name is missing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('يرجى ملء الحقل الخاص بالاسم')),
                    );
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'إضافة',
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
  }
}
