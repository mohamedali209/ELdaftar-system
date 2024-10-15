import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_state.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabat_grid.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/summary_hesbat_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Hesabatcontainer extends StatelessWidget {
  const Hesabatcontainer({super.key});

  void _showAddSupplierDialog(BuildContext context) {
    String supplierName = '';
    String wazna18 = '';
    String wazna21 = '';
    String wazna24 = '';
    String nakdyia = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => SupplierCubit(FirebaseFirestore.instance),
          child: SingleChildScrollView(
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
                  // Main container with padding to make space for the image at the bottom
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0), // Padding to leave space for the image
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
                              'الاسم',
                              (value) => supplierName = value,
                              TextInputType.text),
                          const SizedBox(height: 10),
                          _buildTextField('وزنة 18', (value) => wazna18 = value,
                              TextInputType.number),
                          const SizedBox(height: 10),
                          _buildTextField('وزنة 21', (value) => wazna21 = value,
                              TextInputType.number),
                          const SizedBox(height: 10),
                          _buildTextField('وزنة 24', (value) => wazna24 = value,
                              TextInputType.number),
                          const SizedBox(height: 10),
                          _buildTextField('نقدية', (value) => nakdyia = value,
                              TextInputType.number),
                        ],
                      ),
                    ),
                  ),
                  // Positioned image at the bottom but behind the content
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0, // Make the image full width to look like a footer
                    child: IgnorePointer(
                      // This makes sure the image doesn't block taps
                      child: Image.asset(
                        'assets/images/edafethesab.png', // Adjust the path if needed
                        width: 200, // Set desired width
                        height: 60, // Set desired height
                        fit: BoxFit.cover, // Adjust fit as needed
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
                    const SizedBox(width: 16), // Add space between buttons
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          if (supplierName.isNotEmpty &&
                              wazna18.isNotEmpty &&
                              wazna21.isNotEmpty &&
                              nakdyia.isNotEmpty) {
                            final newSupplier = Hesabmodel(
                              transactions: [],
                              id: '', // Ensure this matches how you initialize the ID
                              suppliername: supplierName,
                              wazna18: wazna18,
                              wazna21: wazna21,
                              wazna24: wazna24,
                              nakdyia: nakdyia,
                            );
                            context
                                .read<SupplierCubit>()
                                .addSupplier(newSupplier);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')),
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
            ),
          ),
        );
      },
    );
  }

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile =
        MediaQuery.of(context).size.width < 600; // Adjust threshold as needed

    return Stack(
      children: [
        // Positioned image background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/Element.png',
            height: 100,
            fit: BoxFit.cover,
          ),
        ),

        // Column for other content
        Positioned(
          top: 0, // Start from the top
          left: 0,
          right: 0,
          bottom: 0, // Fill the remaining space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 40,
              ),
              // Summary list
              const Summaryhesabatlist(),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
                indent: 150,
                endIndent: 150,
                color: Color(0xffF7EAD1),
              ),
              Text(' الحسابات',
                  textDirection: TextDirection.rtl,
                  style: Appstyles.bold50(context)),

              Expanded(
                child: Padding(
                  padding: isMobile
                      ? EdgeInsets.zero // No padding for mobile
                      : const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                  child: Custombackgroundcontainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        IconButton(
                          onPressed: () {
                            _showAddSupplierDialog(context);
                          },
                          icon: Container(
                            height: screenHeight * 0.05, // Fixed height
                            width: screenWidth * 0.2, // Responsive width
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.amber, // Left color
                                  Color(0xFF735600), // Right color
                                ],
                                begin:
                                    Alignment.centerLeft, // Start from the left
                                end: Alignment.centerRight, // End on the right
                              ),
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            child: Center(
                              child: Text(
                                '    اضافة حساب    ',
                                style: Appstyles.regular25(context).copyWith(
                                  color: Colors.white,
                                  fontSize: screenWidth < 600
                                      ? 14
                                      : 16, // Adjust font size based on screen width// Change text color to white
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<SupplierCubit, SupplierState>(
                            builder: (context, state) {
                              if (state is SupplierLoadInProgress) {
                                return const Center(
                                    child: CustomLoadingIndicator());
                              } else if (state is SupplierLoadSuccess) {
                                if (state.suppliers.isEmpty) {
                                  return Center(
                                      child: Text('لا يوجد حسابات',
                                          style: Appstyles.regular25(context)));
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 20, left: 15, right: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                            child: Hesabatgridview(
                                                items: state.suppliers)),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (state is SupplierLoadFailure) {
                                return Center(
                                  child: Text(
                                      'Failed to load suppliers: ${state.error}'),
                                );
                              } else {
                                return const Center(
                                    child: Text('Unexpected state'));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
