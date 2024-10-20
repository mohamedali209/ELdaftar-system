import 'package:aldafttar/features/CollectionEldafaterview/manager/cubit/collectiondfater_cubit.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/date_picker.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/buy_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sell_container.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Eldafater extends StatelessWidget {
  const Eldafater({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: DatePicker(), // This triggers the date selection
              ),
              BlocBuilder<CollectiondfaterCubit, CollectiondfaterState>(
                builder: (context, state) {
                  if (state is CollectiondfaterLoading) {
                    // Show loading indicator after date is selected
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is CollectiondfaterLoaded) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'بيع',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 16),
                                ),
                                Text(
                                  ' -الدفتر ',
                                  style: Appstyles.regular25(context)
                                      .copyWith(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          SellingWidget(
                            items: state.sellingItems,
                            onItemAdded: (newItem) {},
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'شراء',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 16),
                                ),
                                Text(
                                  ' -الدفتر ',
                                  style: Appstyles.regular25(context)
                                      .copyWith(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          BuyingWidget(
                            items: state.buyingItems,
                            onItemAdded: (newItem) {},
                          ),
                        ],
                      ),
                    );
                  } else if (state is CollectiondfaterError) {
                    return SliverToBoxAdapter(
                      child:
                          Center(child: Text('Error: ${state.errorMessage}')),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Center(child: Text('قم ب اختيار التاريخ')),
                        ],
                      ),
                    );
                  }
                },
              ),
              const SliverToBoxAdapter(child: Divider()),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
