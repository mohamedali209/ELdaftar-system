import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_cubit.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_state.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/items_pie_chart.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Buyitemschart extends StatelessWidget {
  const Buyitemschart({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchInsightsCubit, FetchInsightsState>(
      builder: (context, state) {
        if (state is FetchInsightsLoading) {
          return const Center(child: CustomLoadingIndicator());
        } else if (state is FetchInsightsSuccess) {
          final Map<String, double> salesPercentageData =
              state.salesPercentageData;


          final List<Color> colors = [
            const Color(0xFF5BC47B),
            const Color(0xFFDF4EE3),
            const Color(0xFFEB8D3F),
            Colors.red,
            Colors.blue,
            Colors.purple,
            Colors.orange,
            Colors.cyan,
            Colors.green,
            Colors.yellow,
            Colors.pink,
            Colors.brown,
            Colors.teal
          ];

          return Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Ensure the pie chart is passed the same color list
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * .25,
                  child: ItemsCircleChart(
                    salesPercentageData: salesPercentageData,
                    colors: colors,
                  ),
                ),
                // Pass the same items and colors to the list
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
