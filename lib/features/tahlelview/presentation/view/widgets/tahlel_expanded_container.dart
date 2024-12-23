import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_cubit.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/buy_items_chart.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/buy_orsell_row.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/buyorsell_header_period.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/purchase_summary_chart.dart';
import 'package:aldafttar/features/tahlelview/presentation/view/widgets/sales_summary_chart.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tahlelexpandedcontainer extends StatefulWidget {
  const Tahlelexpandedcontainer({super.key});

  @override
  TahlelexpandedcontainerState createState() => TahlelexpandedcontainerState();
}

class TahlelexpandedcontainerState extends State<Tahlelexpandedcontainer> {
  String selectedPeriod = 'سنوي';
  late FetchInsightsCubit fetchInsightsCubit;

  @override
  void initState() {
    super.initState();
    fetchInsightsCubit = FetchInsightsCubit();
    fetchInsightsCubit.fetchInsightsSummary(selectedPeriod);
  }

  void onPeriodChanged(String period) {
    setState(() {
      selectedPeriod = period;
    });
    fetchInsightsCubit
        .fetchInsightsSummary(selectedPeriod); // Fetch data for the new period
  }

  @override
  void dispose() {
    fetchInsightsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: fetchInsightsCubit,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Custombackgroundcontainer(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    children: [
                      PeriodHeader(
                        title: 'المبيعات',
                        selectedPeriod: selectedPeriod,
                        onPeriodChanged: onPeriodChanged,
                      ),
                      SalesSummaryChart(selectedPeriod: selectedPeriod),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Custombackgroundcontainer(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    children: [
                      PeriodHeader(
                        title: 'الشراء',
                        selectedPeriod: selectedPeriod,
                        onPeriodChanged: onPeriodChanged,
                      ),
                      PurchaseSummaryChart(selectedPeriod: selectedPeriod),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Custombackgroundcontainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      PeriodHeader(
                        title: 'نسبة البيع و الشراء',
                        style: Appstyles.daftartodayheader(context),
                        selectedPeriod: selectedPeriod,
                        onPeriodChanged: onPeriodChanged,
                      ),
                      const Buyorselltahlel()
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Custombackgroundcontainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      PeriodHeader(
                        title: 'نسبة البيع من المنتجات ',
                        style: Appstyles.daftartodayheader(context),
                        selectedPeriod: selectedPeriod,
                        onPeriodChanged: onPeriodChanged,
                      ),
                      const Buyitemschart()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
