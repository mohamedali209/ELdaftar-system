import 'package:aldafttar/features/Gardview/presentation/manager/cubit/updateinventory/cubit/updateinventory_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaftarelgardHeader extends StatelessWidget {
  const DaftarelgardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        const Spacer(),
        IconButton(
          onPressed: () {
            _showAddOrMinusDialog(context);
          },
          icon: Custombackgroundcontainer(
            child: Container(
              height: screenHeight * 0.05, // Fixed height
              width: screenWidth * 0.2, // Responsive width
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.amber, // Left color
                    Color(0xFF735600), // Right color
                  ],
                  begin: Alignment.centerLeft, // Start from the left
                  end: Alignment.centerRight, // End on the right
                ),
                border: Border.all(
                  color: const Color(0xFF4D4D4D), // Border color is grey
                ),
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center content horizontally
                children: [
                  Text(
                    'اضافة او تعديل',
                    style: Appstyles.regular25(context).copyWith(
                      color: Colors
                          .white, // Change text color to white for better contrast
                      fontSize: screenWidth < 600
                          ? 14
                          : 16, // Adjust font size based on screen width
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 50,
        ),
      ],
    );
  }

  void _showAddOrMinusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? operation;
        String? jewelryType;
        String? purity;
        TextEditingController weightController = TextEditingController();
        TextEditingController quantityController = TextEditingController();

        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 12, 12, 12), // Set background color
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
              style: Appstyles.regular12cairo(context)
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
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
                Colors.black, // First color
                Color.fromARGB(255, 44, 33, 3), // Second color
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'اختيار العملية'),
                items: const [
                  DropdownMenuItem(value: 'add', child: Text('إضافة')),
                  DropdownMenuItem(value: 'minus', child: Text('خصم')),
                ],
                onChanged: (value) {
                  operation = value;
                },
              ),
              const SizedBox(height: 10), // Space between fields
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'اختيار النوع'),
                items: const [
                  DropdownMenuItem(value: 'خواتم', child: Text('خواتم')),
                  DropdownMenuItem(value: 'دبل', child: Text('دبل')),
                  DropdownMenuItem(value: 'محابس', child: Text('محابس')),
                  DropdownMenuItem(value: 'انسيالات', child: Text('انسيالات')),
                  DropdownMenuItem(value: 'غوايش', child: Text('غوايش')),
                  DropdownMenuItem(value: 'حلقان', child: Text('حلقان')),
                  DropdownMenuItem(value: 'تعاليق', child: Text('تعاليق')),
                  DropdownMenuItem(value: 'كوليهات', child: Text('كوليهات')),
                  DropdownMenuItem(value: 'سلاسل', child: Text('سلاسل')),
                  DropdownMenuItem(value: 'اساور', child: Text('اساور')),
                  DropdownMenuItem(value: 'جنيهات', child: Text('جنيهات')),
                  DropdownMenuItem(value: 'سبائك', child: Text('سبائك')),
                ],
                onChanged: (value) {
                  jewelryType = value;
                },
              ),
              const SizedBox(height: 10), // Space between fields
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'اختيار العيار'),
                items: const [
                  DropdownMenuItem(value: '18k', child: Text('18k')),
                  DropdownMenuItem(value: '21k', child: Text('21k')),
                  DropdownMenuItem(value: '24k', child: Text('24k')),
                ],
                onChanged: (value) {
                  purity = value;
                },
              ),
              const SizedBox(height: 10), // Space between fields
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'الوزن'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10), // Space between fields
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'الكمية'),
                keyboardType: TextInputType.number,
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
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
          ),
          const SizedBox(width: 16), // Space between buttons
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                if (operation != null &&
                    weightController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    jewelryType != null &&
                    purity != null) {
                  double weight = double.tryParse(weightController.text) ?? 0;
                  int quantity = int.tryParse(quantityController.text) ?? 0;
          
                  BlocProvider.of<UpdateInventoryCubit>(context)
                      .updateInventory(
                    type: jewelryType!,
                    weight: weight,
                    quantity: quantity,
                    purity: purity!,
                    operation: operation!,
                  );
                }
          
                Navigator.of(context).pop();
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
              ),
            ],
          ),
        );

      },
    );
  }
}
