import 'package:aldafttar/features/daftarview/presentation/view/manager/summarylist/cubit/summary_item_cubit.dart';
import 'package:aldafttar/features/daftarview/presentation/view/manager/summarylist/cubit/summary_item_state.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftar_item.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Summarydftarlist extends StatelessWidget {
  const Summarydftarlist({super.key, required this.onItemAdded});

  // This callback will be triggered when an item is added
  final VoidCallback onItemAdded;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SummaryDftarCubit()..fetchData(),
      child: BlocBuilder<SummaryDftarCubit, SummaryDftarState>(
        builder: (context, state) {
          if (state is SummaryDftarLoading) {
            return const Center(child: CustomLoadingIndicator());
          } else if (state is SummaryDftarError) {
            return Center(
                child: Text(
              state.message,
              style: Appstyles.regular25(context),
            ));
          } else if (state is SummaryDftarLoaded) {
            final items = state.items;

            if (items.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffCC9900), // Amber background color
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: List.generate(
                          items.length > 2 ? items.length - 2 : items.length,
                          (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: SummaryHeadersDaftaritem(
                            daftarmodel: items[index],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 20.0), // Space between containers

                  if (items.length > 2)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: const Color(0xffCC9900),
                            width: 2), // Amber border
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: List.generate(2, (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: SummaryHeadersDaftaritem(
                              color: const Color.fromARGB(255, 31, 30, 30),
                              daftarmodel: items[
                                  items.length - 2 + index], // Last two items
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
