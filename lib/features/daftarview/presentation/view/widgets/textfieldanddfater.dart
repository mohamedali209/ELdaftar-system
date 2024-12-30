import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/utils/custom_textfields.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class Textfieldanddfater extends StatelessWidget {
  const Textfieldanddfater({
    super.key,
    required this.onItemAdded,
  });
  final Function(Daftarcheckmodel) onItemAdded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                CustombuttonAddorSubtract(
                  onItemAdded: onItemAdded,
                ),
                const SizedBox(
                  width: 35,
                )
              ],
            )
          ])
        ],
      ),
    );
  }
}

class CustombuttonAddorSubtract extends StatelessWidget {
  const CustombuttonAddorSubtract({
    super.key,
    required this.onItemAdded,
  });
  final Function(Daftarcheckmodel) onItemAdded;

  // Callback function to show the dialog
  void _showAddItemDialog(BuildContext context) {
    final TextEditingController adadController = TextEditingController();
    final TextEditingController gramController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    String selectedDetail = 'خاتم';
    String selectedAyar = '18k'; // Default value for 'عيار'

    final List<String> detailsOptions = [
      'خاتم',
      'دبلة',
      'توينز',
      'سلسلة',
      'حلق',
      'محبس',
      'انسيال',
      'اسورة',
      'تعليقة',
      'كوليه',
      'غوايش',
      'سبائك',
      'جنيهات',
    ];

    final List<String> ayarOptions = [
      '18k',
      '21k',
      '24k'
    ]; // Options for 'عيار'
    final List<String> restrictedItems = [
      'خاتم',
      'دبلة',
      'توينز',
      'سلسلة',
      'حلق',
      'محبس',
      'انسيال',
      'اسورة',
      'تعليقة',
      'كوليه',
      'غوايش',
      'جنيهات',
    ]; // Items where 24k is not allowed
    showDialog(
      context: context,
      builder: (context) {
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
                      'اضافة منتج',
                      style: Appstyles.daftartodayheader(context).copyWith(
                        fontSize: 25,
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
                        Colors.black, // First color
                        Color.fromARGB(255, 44, 33, 3), // Second color
                      ],
                      stops: [
                        0.80,
                        1.0
                      ], // Adjusts where each color starts and ends
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Details Dropdown
                        CustomDropdown(
                          value: selectedDetail,
                          items: detailsOptions,
                          onChanged: (newValue) {
                            selectedDetail = newValue!;
                            // Automatically set Ayar based on the selected detail
                            if (selectedDetail == 'سبائك') {
                              selectedAyar = '24k';
                            } else if (selectedDetail == 'جنيهات') {
                              selectedAyar = '21k';
                            }
                          },
                          labelText: 'الصنف',
                          validator: (value) =>
                              value == null ? 'Field required' : null,
                        ),
                        const SizedBox(height: 10), // Space between fields

                        // Number Field
                        CustomTextField2(
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow digits only
                          ],
                          keyboardType: TextInputType.number,
                          controller: adadController,
                          hintText: '...ادخل العدد',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'رقم فقط';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10), // Space between fields

                        // Gram and Price Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextField2(
                                keyboardType: TextInputType.number,
                                controller: gramController,
                                hintText: '...ادخل الجرام',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field required';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'رقم فقط';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                                width: 16), // Add space between fields
                            Expanded(
                              child: CustomTextField2(
                                keyboardType: TextInputType.number,
                                controller: priceController,
                                hintText: '...ادخل السعر',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field required';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'رقم فقط';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Allow digits only
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Space between fields

                        // Ayar Dropdown
                        CustomDropdown(
                          value: selectedAyar,
                          items: ayarOptions,
                          onChanged: (newValue) {
                            selectedAyar = newValue!;
                          },
                          labelText: 'عيار',
                          validator: (value) {
                            if (value == null) return 'Field required';
                            // Validate Ayar for restricted items
                            if (restrictedItems.contains(selectedDetail) &&
                                selectedAyar == '24k') {
                              return 'هذا العيار غير مسموح للصنف المختار';
                            }
                            return null;
                          },
                        ),

                        // Details TextField
                        CustomTextField2(
                          keyboardType: TextInputType.text,
                          controller: detailsController,
                          hintText: '...يوجد تفاصيل ؟',
                          validator: (value) {
                            // Allow empty details
                            return null;
                          },
                        ),
                      ],
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 12), // Match padding here
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('الغاء'),
                    ),
                  ),
                  const SizedBox(width: 16), // Add space between buttons
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12), // Match padding here
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final newItem = Daftarcheckmodel(
                            tfasel: detailsController.text,
                            gram: gramController.text,
                            num: '',
                            details: selectedDetail,
                            adad: adadController.text,
                            price: priceController.text,
                            ayar: selectedAyar,
                          );

                          // Add the item first
                          onItemAdded(newItem);

                          // Close the dialog after fetching data
                          Navigator.of(context).pop();
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
                          borderRadius:
                              BorderRadius.circular(15), // Adjust as needed
                        ),
                        child: const Center(
                          child: Text(
                            'اضافة',
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

  @override
  Widget build(BuildContext context) {
    // Get the screen width to adjust the font size dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: () {
        // Trigger the dialog when the button is tapped
        _showAddItemDialog(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Solid black background color

        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          side: const BorderSide(color: Color(0xFF4D4D4D)), // Border color
        ),
        fixedSize:
            Size(screenWidth * 0.3, screenHeight * 0.03), // Responsive size
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content horizontally
        children: [
          Text(
            'اضافة',
            style: Appstyles.regular25(context).copyWith(
              color: Colors.amber, // Text color
              fontSize: screenWidth < 600
                  ? 14
                  : 16, // Adjust font size based on screen width
            ),
          ),
          const SizedBox(width: 4), // Space between text and icon
          SvgPicture.asset(
            'assets/images/plus.svg',
            height: screenHeight * 0.015, // Adjusted size
            width: screenWidth * 0.03, // Adjusted size
          ),
        ],
      ),
    );
  }
}
