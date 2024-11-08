import 'package:aldafttar/features/Gardview/presentation/manager/cubit/updateinventory/cubit/updateinventory_cubit.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/add_minus_dialog.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/add_minus_nakdyia_dialog.dart';
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
        IconButton(
          onPressed: () {
            _showAddOrMinusDialogNakdyia(context);
          },
          icon: Custombackgroundcontainer(
            child: Container(
              height: screenHeight * 0.05, // Fixed height
              width: screenWidth * 0.25, // Responsive width
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
                    'اضافة او تعديل نقدية ',
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
        const Spacer(),
        IconButton(
          onPressed: () {
            _showAddOrMinusDialog(context);
          },
          icon: Custombackgroundcontainer(
            child: Container(
              height: screenHeight * 0.05, // Fixed height
              width: screenWidth * 0.25, // Responsive width
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
                    'اضافة او تعديل وزنة',
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
      ],
    );
  }

  void _showAddOrMinusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<UpdateInventoryCubit>(context),
        child: const AddOrMinusDialog(),
      ),
    );
  }

  void _showAddOrMinusDialogNakdyia(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<UpdateInventoryCubit>(context),
        child: const UpdateCashDialog(),
      ),
    );
  }
}
