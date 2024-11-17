import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_cubit.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_state.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/custom_line_chart.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesSummaryChart extends StatelessWidget {
  final String selectedPeriod;

  const SalesSummaryChart({super.key, required this.selectedPeriod});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchInsightsCubit, FetchInsightsState>(
      builder: (context, state) {
        if (state is FetchInsightsLoading) {
          return const Center(child: CustomLoadingIndicator());
        } else if (state is FetchInsightsFailure) {
          return Center(child: Text(state.error));
        } else if (state is FetchInsightsSuccess) {
          return CustomLineChart(dataPoints: state.salesData);
        }
        return const Center(child: Text('Select a period to view data.'));
      },
    );
  }
}
