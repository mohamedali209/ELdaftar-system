import 'package:aldafttar/features/Gardview/presentation/manager/cubit/gard_header_cubit.dart';
import 'package:aldafttar/features/Gardview/presentation/manager/cubit/gard_header_state.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftar_item.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GardHeader extends StatelessWidget {
  const GardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GardHeaderCubit()..fetchData(),
      child: BlocBuilder<GardHeaderCubit, GardHeaderState>(
        builder: (context, state) {
          if (state is GardHeaderLoading) {
            return const Center(child: CustomLoadingIndicator());
          } else if (state is GardHeaderError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is GardHeaderLoaded) {
            final total18kWeight = state.total18kWeight;
            final total21kWeight = state.total21kWeight;
            final totalkasr18 = state.totalkKasr18;
            final totalkasr21 = state.totalkKasr21;
            final sbayekquantity = state.sabekayekQuantity;
            final sbayekweight = state.sbaekayekWeight;
            final totalkasrAll = state.totalkKasrAll;
            final totalinventoryAll = state.totalinventoryAll;

            return Container(
              decoration: BoxDecoration(
                      color: const Color(0xffCC9900), // Amber background color
                      borderRadius: BorderRadius.circular(15),
                    ),
              height: 150, // Height of the header
              child: ListView(
                scrollDirection: Axis.horizontal, // Horizontal scroll direction
                children: [
                  SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title: 'عيار 18',
                      subtitle: total18kWeight.toStringAsFixed(2),
                    ),
                  ),
                  SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title: 'عيار 21',
                      subtitle: total21kWeight.toStringAsFixed(2),
                    ),
                  ),
                  SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title: ' عدد السبائك',
                      subtitle: sbayekquantity.toStringAsFixed(0),
                    ),
                  ),
                  SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title: 'وزن السبائك',
                      subtitle: sbayekweight.toStringAsFixed(2),
                    ),
                  ),
                  SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title: ' الكسر 18',
                      subtitle: totalkasr18.toStringAsFixed(2),
                    ),
                  ),
                  SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title: ' الكسر 21',
                      subtitle: totalkasr21.toStringAsFixed(2),
                    ),
                  ),
                    SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title: ' اجمالي الكسر 21 \n شامل وزن 18 +وزن 21',
                      subtitle: totalkasrAll.toStringAsFixed(2),
                    ),
                  ),
                  SummaryHeadersDaftaritem(
                    daftarmodel: DaftarheaderModel(
                      title:
                          '  اجمالي الوزنة 21 \n شامل وزن 18 +وزن 21 +وزن السبائك',
                      subtitle: totalinventoryAll.toStringAsFixed(2),
                    ),
                  ), 
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
