import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_cubit.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_state.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/buy_or_sell_chart.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/color_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Buyorselltahlel extends StatelessWidget {
  const Buyorselltahlel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchInsightsCubit, FetchInsightsState>(
      builder: (context, state) {
        if (state is FetchInsightsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchInsightsSuccess) {
          // Here you pass the fetched sales and purchases data
          return Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    height: MediaQuery.sizeOf(context).height * .25,
                    child: BuyorSellItemsCircleChart(
                      sales: state.salesData.fold(0.0, (sum, item) => sum + item), 
                      purchases: state.purchaseData.fold(0.0, (sum, item) => sum + item),
                    )),
                const SizedBox(
                  width: 100,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LegendItem(color: Colors.green, label: 'بيع'),
                      LegendItem(color: Colors.blue, label: 'شراء'),
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (state is FetchInsightsFailure) {
          return Center(child: Text(state.error));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
