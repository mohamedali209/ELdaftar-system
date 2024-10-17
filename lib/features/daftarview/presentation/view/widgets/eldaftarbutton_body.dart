import 'package:aldafttar/features/daftarview/presentation/view/manager/cubit/items_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/cubit/items_state.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/summarylist/cubit/summary_item_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/buy_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/end_day_button.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sell_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftr_list.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DaftarToday extends StatelessWidget {
  const DaftarToday({super.key});
  @override
  Widget build(BuildContext context) {
    return const DaftarTodayContent();
  }
}

class DaftarTodayContent extends StatelessWidget {
  const DaftarTodayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsCubit, ItemsState>(
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
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 100, // Increased height to make space for summary items
              ),
            ),
            // Rest of the content placed after the image
            Positioned(
              top: 0, // Adjusted the top to start from the top
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomScrollView(
                slivers: [
                  // Sliver for summary list
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(
                            height: 40), // Space for the background image
                        Summarydftarlist(
                          onItemAdded: () {
                            context.read<SummaryDftarCubit>().fetchData();
                          },
                        ),
                        const SizedBox(
                            height: 10), // Optionally add space below
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      thickness: 2,
                      indent: 150,
                      endIndent: 150,
                      color: Color(0xffF7EAD1),
                    ),
                  ),
                  // Sell Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'بيع',
                            style: TextStyle(color: Colors.amber, fontSize: 16),
                          ),
                          Text(
                            ' -الدفتر اليومي',
                            style: Appstyles.regular25(context)
                                .copyWith(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SellingWidget(
                      onItemAdded: (newItem) {
                        context.read<ItemsCubit>().addSellingItem(
                              newItem,
                            );
                      },
                      items: state.sellingItems,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 15),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      thickness: 2,
                      indent: 150,
                      endIndent: 150,
                      color: Color(0xffF7EAD1),
                    ),
                  ),
                  // Buy Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'شراء',
                            style: TextStyle(color: Colors.amber, fontSize: 16),
                          ),
                          Text(
                            ' -الدفتر اليومي',
                            style: Appstyles.regular25(context)
                                .copyWith(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BuyingWidget(
                      onItemAdded: (newItem) {
                        context.read<ItemsCubit>().addBuyingItem(newItem);
                      },
                      items: state.buyingItems,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(
                      color: Color.fromARGB(255, 114, 110, 110),
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 10,
                  )),
                  const SliverToBoxAdapter(
                    child: EndDayButton(),
                  ),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 20,
                  ))
                ],
              ),
            ),
            // Red button at the bottom-right of the screen
          ],
        );
      },
    );
  }
}
