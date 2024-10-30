import 'package:aldafttar/features/daftarview/presentation/view/widgets/buy_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sell_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/titles_daftar.dart';
import 'package:aldafttar/features/employeesdftar/manager/cubit/employeesitem_cubit.dart'; // Import your cubit
import 'package:aldafttar/features/employeesdftar/manager/cubit/employeesitem_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesDftarBody extends StatelessWidget {
  const EmployeesDftarBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesitemCubit, EmployeesitemState>(
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
                const SliverToBoxAdapter(
                  child: Divider(
                    thickness: 2,
                    indent: 150,
                    endIndent: 150,
                    color: Color(0xffF7EAD1),
                  ),
                ),
                // Sell Section
                const SliverToBoxAdapter(
                  child: TitleSelling(),
                ),
                SliverToBoxAdapter(
                  child: SellingWidget(
                    onItemAdded: (newItem) {
                      context.read<EmployeesitemCubit>().addSellingItem(newItem);
                    },
                    items:
                        state.sellingItems, // Use the selling items from state
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
                const SliverToBoxAdapter(
                  child: TitleBuying(),
                ),
                SliverToBoxAdapter(
                  child: BuyingWidget(
                    onItemAdded: (newItem) {
                      context.read<EmployeesitemCubit>().addBuyingItem(newItem);
                    },
                    items: state.buyingItems, // Use the buying items from state
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
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
