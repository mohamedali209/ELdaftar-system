import 'package:aldafttar/features/Gardview/presentation/manager/cubit/updateinventory/cubit/updateinventory_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCashDialog extends StatefulWidget {
  const UpdateCashDialog({super.key});

  @override
  UpdateCashDialogState createState() => UpdateCashDialogState();
}

class UpdateCashDialogState extends State<UpdateCashDialog> {
  final TextEditingController cashController = TextEditingController();
  String selectedOperation = 'إضافة'; // Default operation is "Add"

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
                  'إضافة أو تعديل نقدية',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                  // Dropdown for selecting operation (Add or Subtract)
                  buildDropdown(
                    label: 'اختيار العملية',
                    items: const [
                      DropdownMenuItem(value: 'إضافة', child: Text('إضافة')),
                      DropdownMenuItem(value: 'خصم', child: Text('خصم')),
                    ],
                    onChanged: (value) {
                      selectedOperation = value.toString();
                    },
                  ),
                  const SizedBox(height: 10),

                  // TextField for entering the cash amount
                  buildTextField(
                    controller: cashController,
                    labelText: 'أدخل المبلغ',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('إلغاء', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              final double? cashAmount = double.tryParse(cashController.text);
              if (cashAmount != null) {
                context.read<UpdateInventoryCubit>().updateTotalCash(
                      operation: selectedOperation,
                      amount: cashAmount,
                    );
                Navigator.pop(context); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال مبلغ صالح')),
                );
              }
            },
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
    );
  }

  Widget buildDropdown({
    required String label,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: items,
      onChanged: onChanged,
    );
  }
}
