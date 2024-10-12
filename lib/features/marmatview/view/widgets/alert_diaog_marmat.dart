import 'package:aldafttar/features/marmatview/manager/cubit/marmat_cubit.dart';
import 'package:aldafttar/features/marmatview/model/marmat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertdialogMarmat extends StatelessWidget {
  const AlertdialogMarmat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Fields for the form
    String product = '';
    String repairRequirements = '';
    String paidAmount = '';
    String remainingAmount = '';
    String customerName = '';
    String note = '';

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
                  'اضافة مرمة',
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
            // Main container with padding to make space for the image at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Padding to leave space for the image
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
                    _buildTextField(
                      
                      'المنتج', (value) => product = value,TextInputType.text,),
                    const SizedBox(height: 5),
                    _buildTextField(
                        'متطلبات التصليح', (value) => repairRequirements = value,TextInputType.text,),
                    const SizedBox(height: 5),
                    _buildTextField('تم دفعه', (value) => paidAmount = value,TextInputType.number,),
                    const SizedBox(height: 5),
                    _buildTextField(
                        'المتبقي من الحساب', (value) => remainingAmount = value,TextInputType.number,),
                    const SizedBox(height: 5),
                    _buildTextField(
                        'اسم العميل', (value) => customerName = value,TextInputType.text,),
                    const SizedBox(height: 5),
                    _buildTextField('ملحوظة ', (value) => note = value,TextInputType.text,),
                  ],
                ),
              ),
            ),
            // Positioned image at the bottom but behind the content
            Positioned(
              bottom: 0,
              right: 0,
              left: 0, // Make the image full width to look like a footer
              child: IgnorePointer( // This makes sure the image doesn't block taps
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
                    // Create a new MarmatModel instance
                    final newMarmat = MarmatModel(
                      isRepaired: false,
                      id: '',
                      product: product,
                      repairRequirements: repairRequirements,
                      paidAmount: paidAmount,
                      remainingAmount: remainingAmount,
                      customerName: customerName,
                      note: note,
                    );

                    // Call the addMarmatItem method from the cubit
                    context.read<MarmatCubit>().addMarmatItem(newMarmat);
                    Navigator.of(context)
                        .pop(); // Close the dialog after adding
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
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,TextInputType? keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType:keyboardType ,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color.fromARGB(255, 25, 25, 25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }
}
