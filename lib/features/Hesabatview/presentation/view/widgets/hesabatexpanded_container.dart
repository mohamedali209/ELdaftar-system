import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_state.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/add_supplier_dialog.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesabat_grid.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/summary_hesbat_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Hesabatcontainer extends StatelessWidget {
  const Hesabatcontainer({super.key});

  void _showAddSupplierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<SupplierCubit>(context),
        child: const SingleChildScrollView(child: AddSupplierDialog()),
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
                                    height:
                                        300, // Set the height of the container
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                    ),
                                    child: Stack(
                                      children: [
                                        // Image positioned at the bottom-right
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Image.asset(
                                            'assets/images/hesabbackground.png',
                                            height:
                                                100, // Adjust height as needed for the image
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Content inside the black container
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(height: 10),
                                            Expanded(
                                              child: Hesabatgridview(
                                                  items: state.suppliers),
                                            ),
                                          ],
                                        ),
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
