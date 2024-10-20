import 'package:aldafttar/features/CollectionEldafaterview/manager/cubit/collectiondfater_cubit.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/collection_titles.dart';
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
                child: DatePicker(),
              ),
              BlocBuilder<CollectiondfaterCubit, CollectiondfaterState>(
                builder: (context, state) {
                  if (state is CollectiondfaterLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is CollectiondfaterLoaded) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Selling Section
                          const TitlesellingCollection(),
                          SellingWidget(
                            items: state.sellingItems,
                            onItemAdded: (newItem) {},
                          ),
                          // Buying Section
                          const TitleBuyingCollection(),
                          BuyingWidget(
                            items: state.buyingItems,
                            onItemAdded: (newItem) {},
                          ),
                          // Expenses Section
                          const TitleexpensesCollection(),
                          // Display the expenses in a ListView
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.expenses.length,
                            itemBuilder: (context, index) {
                              final expense = state.expenses[index];
                              return ListTile(
                                title:
                                    Text(expense.description), // Example field
                                trailing: Text(
                                  '${expense.amount}',
                                  style: Appstyles.regular25(context),
                                ),
                              );
                            },
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
