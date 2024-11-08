import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/marmatview/manager/cubit/marmat_cubit.dart';
import 'package:aldafttar/features/marmatview/manager/cubit/marmat_state.dart';
import 'package:aldafttar/features/marmatview/view/widgets/alert_diaog_marmat.dart';
import 'package:aldafttar/features/marmatview/view/widgets/marmat_gridview.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Marmatexpandedcontainer extends StatelessWidget {
  const Marmatexpandedcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) {
        final cubit = MarmatCubit(firestore: FirebaseFirestore.instance);
        cubit.streamMarmatItems(); // Start listening to the stream
        return cubit;
      },
      child: BlocBuilder<MarmatCubit, MarmatState>(
        builder: (context, state) {
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
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 40),
                    const Divider(
                      thickness: 2,
                      indent: 150,
                      endIndent: 150,
                      color: Color(0xffF7EAD1),
                    ),

                    Text(
                      ' المرمات',
                      textDirection: TextDirection.rtl,
                      style: Appstyles.bold50(context),
                    ),

                    const SizedBox(height: 20),

                    // Custom Background Container
                    Expanded(
                      child: Custombackgroundcontainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: Container(
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
                                    'assets/images/marmatbackground.png',
                                    height: 300, // Adjust the height as needed
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Content inside the black container
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 10),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) =>
                                              BlocProvider.value(
                                            value: BlocProvider.of<MarmatCubit>(
                                                context),
                                            child: const AlertdialogMarmat(),
                                          ),
                                        );
                                      },
                                      icon: Container(
                                        height:
                                            screenHeight * 0.05, // Fixed height
                                        width: screenWidth *
                                            0.2, // Responsive width
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.amber,
                                              Color(0xFF735600),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'اضافة مرمة',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: state is MarmatLoading
                                          ? const Center(
                                              child: CustomLoadingIndicator())
                                          : state is MarmatError
                                              ? Center(
                                                  child: Text(
                                                      'Error: ${state.message}'))
                                              : state is MarmatLoaded
                                                  ? Marmatgridview(
                                                      items: state.items)
                                                  : Center(
                                                      child: Text(
                                                        'لا يوجد مرمات',
                                                        style: Appstyles
                                                            .regular12cairo(
                                                                context),
                                                      ),
                                                    ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
