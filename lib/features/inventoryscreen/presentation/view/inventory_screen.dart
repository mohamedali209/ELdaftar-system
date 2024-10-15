import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/inventoryscreen/presentation/manager/cubit/inventory_cubit_cubit.dart';
import 'package:aldafttar/features/inventoryscreen/presentation/manager/cubit/inventory_cubit_state.dart';
import 'package:aldafttar/features/inventoryscreen/presentation/view/widgets/custom_inventory_textfield.dart';
import 'package:aldafttar/utils/app_router.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Element.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 100,
            ),
          ),
          Positioned(
            top: 50, // Adjust this value to position the text vertically
            right: 16, // Adjust the right padding as needed
            child: Text(
              'تسجيل المخزون',
              style: Appstyles.bold50(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state is InventoryUpdated) {
                  final controllers = state.controllers;
                  final formKey = GlobalKey<FormState>(); // Form key

                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (String type in [
                              'خواتم',
                              'دبل',
                              'محابس',
                              'انسيالات',
                              'غوايش',
                              'حلقان',
                              'تعاليق',
                              'كوليهات',
                              'سلاسل',
                              'اساور'
                            ])
                              Column(
                                children: [
                                  Custombackgroundcontainer(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                          left: 20,
                                          right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.black,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                bottom: 0,
                                                right:
                                                    0, // Adjust this value for horizontal positioning
                                                child: Image.asset(
                                                  'assets/images/inventorypic.png',
                                                  width:
                                                      300, // Adjust width as needed
                                                  height:
                                                      200, // Adjust height as needed
                                                ),
                                              ),
                                              // Column of TextFields
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  ShaderMask(
                                                    shaderCallback: (bounds) =>
                                                        const LinearGradient(
                                                      colors: [
                                                        Colors
                                                            .amber, // Color on the left
                                                        Color(0xff735600),
                                                      ],
                                                      tileMode: TileMode.clamp,
                                                    ).createShader(bounds),
                                                    child: Text(
                                                      type,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        // No color here, since we're using a ShaderMask
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            CustomTextFieldInventory(
                                                          controller:
                                                              TextEditingController(
                                                            text: controllers[
                                                                '${type}_18k_quantity'],
                                                          ),
                                                          labelText:
                                                              '18k عدد القطع',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (value) => context
                                                              .read<
                                                                  InventoryCubit>()
                                                              .setControllerValue(
                                                                  '${type}_18k_quantity',
                                                                  value),
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Field required';
                                                            }
                                                            if (double.tryParse(
                                                                    value) ==
                                                                null) {
                                                              return 'رقم فقط';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child:
                                                            CustomTextFieldInventory(
                                                          controller:
                                                              TextEditingController(
                                                            text: controllers[
                                                                '${type}_21k_quantity'],
                                                          ),
                                                          labelText:
                                                              '21k عدد القطع',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (value) => context
                                                              .read<
                                                                  InventoryCubit>()
                                                              .setControllerValue(
                                                                  '${type}_21k_quantity',
                                                                  value),
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Field required';
                                                            }
                                                            if (double.tryParse(
                                                                    value) ==
                                                                null) {
                                                              return 'رقم فقط';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 50),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            CustomTextFieldInventory(
                                                          controller:
                                                              TextEditingController(
                                                            text: controllers[
                                                                '${type}_18k_weight'],
                                                          ),
                                                          labelText:
                                                              '18k الوزن',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (value) => context
                                                              .read<
                                                                  InventoryCubit>()
                                                              .setControllerValue(
                                                                  '${type}_18k_weight',
                                                                  value),
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Field required';
                                                            }
                                                            if (double.tryParse(
                                                                    value) ==
                                                                null) {
                                                              return 'رقم فقط';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child:
                                                            CustomTextFieldInventory(
                                                          controller:
                                                              TextEditingController(
                                                            text: controllers[
                                                                '${type}_21k_weight'],
                                                          ),
                                                          labelText:
                                                              '21k الوزن',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (value) => context
                                                              .read<
                                                                  InventoryCubit>()
                                                              .setControllerValue(
                                                                  '${type}_21k_weight',
                                                                  value),
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Field required';
                                                            }
                                                            if (double.tryParse(
                                                                    value) ==
                                                                null) {
                                                              return 'رقم فقط';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                ],
                              ),

                            // Add fields for سبائك and جنيهات
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Colors.amber, // Color on the right
                                      Color(0xff735600), // Color on the left
                                    ],
                                    tileMode: TileMode.clamp,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'سبائك',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      // No color here since we're using a ShaderMask
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFieldInventory(
                                        controller: TextEditingController(
                                          text: controllers['sabaek_count'],
                                        ),
                                        labelText: 'سبائك عدد القطع',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => context
                                            .read<InventoryCubit>()
                                            .setControllerValue(
                                                'sabaek_count', value),
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextFieldInventory(
                                        controller: TextEditingController(
                                          text: controllers['sabaek_weight'],
                                        ),
                                        labelText: 'سبائك الوزن',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => context
                                            .read<InventoryCubit>()
                                            .setControllerValue(
                                                'sabaek_weight', value),
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
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Colors.amber, // Color on the right
                                      Color(0xff735600), // Color on the left
                                    ],
                                    tileMode: TileMode.clamp,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'جنيهات',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      // No color here since we're using a ShaderMask
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFieldInventory(
                                        controller: TextEditingController(
                                          text: controllers['gnihat_count'],
                                        ),
                                        labelText: 'جنيهات عدد القطع',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => context
                                            .read<InventoryCubit>()
                                            .setControllerValue(
                                                'gnihat_count', value),
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextFieldInventory(
                                        controller: TextEditingController(
                                          text: controllers['gnihat_weight'],
                                        ),
                                        labelText: 'جنيهات الوزن',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => context
                                            .read<InventoryCubit>()
                                            .setControllerValue(
                                                'gnihat_weight', value),
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
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            // Fields for كسر and نقديه
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Colors.amber, // Color on the right
                                      Color(0xff735600), // Color on the left
                                    ],
                                    tileMode: TileMode.clamp,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'كسر',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      // No color here since we're using a ShaderMask
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFieldInventory(
                                        controller: TextEditingController(
                                          text: controllers['18k_kasr'],
                                        ),
                                        labelText: '18k كسر',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => context
                                            .read<InventoryCubit>()
                                            .setControllerValue(
                                                '18k_kasr', value),
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextFieldInventory(
                                        controller: TextEditingController(
                                          text: controllers['21k_kasr'],
                                        ),
                                        labelText: '21k كسر',
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => context
                                            .read<InventoryCubit>()
                                            .setControllerValue(
                                                '21k_kasr', value),
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
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Colors.amber, // Color on the right
                                      Color(0xff735600), // Color on the left
                                    ],
                                    tileMode: TileMode.clamp,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'نقدية',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      // No color here since we're using a ShaderMask
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextFieldInventory(
                                  controller: TextEditingController(
                                    text: controllers['cash'],
                                  ),
                                  labelText: 'نقديه',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => context
                                      .read<InventoryCubit>()
                                      .setControllerValue('total_cash', value),
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
                                const SizedBox(height: 20),
                              ],
                            ),
                            // Save Button
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.amber, // Color on the left
                                    Color(0xFFBF8F00), // Color on the right
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .transparent, // Make background transparent
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    context
                                        .read<InventoryCubit>()
                                        .calculateTotals();
                                  } else {
                                    debugPrint('Form validation failed');
                                  }
                                },
                                child: const Text(
                                  'حفظ',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is InventoryTotalsCalculated) {
                  // Debugging statement
                  debugPrint('InventoryTotalsCalculated state reached');

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'إجمالي وزن 18: ${state.total18kWeight.toStringAsFixed(2)} جرام\n'
                          'إجمالي وزن 21: ${state.total21kWeight.toStringAsFixed(2)} جرام\n'
                          'إجمالي كسر 18: ${state.total18kKasr.toStringAsFixed(2)}\n'
                          'إجمالي كسر 21: ${state.total21kKasr.toStringAsFixed(2)}\n'
                          'إجمالي النقدية: ${state.totalCash.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );

                    Future.delayed(const Duration(seconds: 3), () {
                      GoRouter.of(context).push(AppRouter.kDaftarview);
                    });
                  });
                }

                return const Center(child: CustomLoadingIndicator());
              },
            ),
          ),
        ]),
      ),
    );
  }
}
