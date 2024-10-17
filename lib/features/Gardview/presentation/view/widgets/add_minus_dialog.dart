import 'package:aldafttar/features/Gardview/presentation/manager/cubit/updateinventory/cubit/updateinventory_cubit.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddOrMinusDialog extends StatefulWidget {
  const AddOrMinusDialog({super.key});

  @override
  AddOrMinusDialogState createState() => AddOrMinusDialogState();
}

class AddOrMinusDialogState extends State<AddOrMinusDialog> {
  String? operation;
  String? jewelryType;
  String? purity;
  TextEditingController weightController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

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
                child: Text(
                  'إضافة أو تعديل وزنة',
                  style: Appstyles.regular12cairo(context).copyWith(
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
                  buildDropdown(
                    label: 'اختيار العملية',
                    items: const [
                      DropdownMenuItem(value: 'add', child: Text('إضافة')),
                      DropdownMenuItem(value: 'minus', child: Text('خصم')),
                    ],
                    onChanged: (value) {
                      operation = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  buildDropdown(
                    label: 'اختيار النوع',
                    items: const [
                      DropdownMenuItem(value: 'خواتم', child: Text('خواتم')),
                      DropdownMenuItem(value: 'دبل', child: Text('دبل')),
                      DropdownMenuItem(value: 'محابس', child: Text('محابس')),
                      DropdownMenuItem(
                          value: 'انسيالات', child: Text('انسيالات')),
                      DropdownMenuItem(value: 'غوايش', child: Text('غوايش')),
                      DropdownMenuItem(value: 'حلقان', child: Text('حلقان')),
                      DropdownMenuItem(value: 'تعاليق', child: Text('تعاليق')),
                      DropdownMenuItem(
                          value: 'كوليهات', child: Text('كوليهات')),
                      DropdownMenuItem(value: 'سلاسل', child: Text('سلاسل')),
                      DropdownMenuItem(value: 'اساور', child: Text('اساور')),
                      DropdownMenuItem(value: 'جنيهات', child: Text('جنيهات')),
                      DropdownMenuItem(value: 'سبائك', child: Text('سبائك')),
                    ],
                    onChanged: (value) {
                      jewelryType = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  buildDropdown(
                    label: 'اختيار العيار',
                    items: const [
                      DropdownMenuItem(value: '18k', child: Text('18k')),
                      DropdownMenuItem(value: '21k', child: Text('21k')),
                      DropdownMenuItem(value: '24k', child: Text('24k')),
                    ],
                    onChanged: (value) {
                      purity = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    controller: weightController,
                    labelText: 'الوزن',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    controller: quantityController,
                    labelText: 'الكمية',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          buildDialogActions(context),
        ],
      ),
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

  Widget buildDialogActions(BuildContext context) {
    return Row(
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
              // Validate input before proceeding
              if (operation != null && jewelryType != null && purity != null) {
                final weightInput = weightController.text;
                final quantityInput = quantityController.text;

                // Validate weight
                final weight = double.tryParse(weightInput);
                if (weight == null) {
                  showErrorDialog(context, 'الرجاء إدخال وزن صحيح');
                  return;
                }

                // Validate quantity
                final quantity = int.tryParse(quantityInput);
                if (quantity == null) {
                  showErrorDialog(context, 'الرجاء إدخال كمية صحيحة');
                  return;
                }

                // Proceed to update the inventory
                BlocProvider.of<UpdateInventoryCubit>(context).updateInventory(
                  type: jewelryType!,
                  weight: weight,
                  quantity: quantity,
                  purity: purity!,
                  operation: operation!,
                );

                Navigator.of(context).pop();
              } else {
                showErrorDialog(context, 'الرجاء اختيار جميع الحقول المطلوبة');
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
                  'تأكيد',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Center(child: Text('خطأ')),
        content: Text(message, style: Appstyles.regular25(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
