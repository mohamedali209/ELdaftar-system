import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_cubit.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/manager/cubit/supplier_state.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/summary_daftar_item.dart';
import 'package:aldafttar/utils/commas.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Summaryhesabatlist extends StatelessWidget {
  const Summaryhesabatlist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierCubit, SupplierState>(
      builder: (context, state) {
        if (state is SupplierLoadSuccess) {
          final List<DaftarheaderModel> items = [
            DaftarheaderModel(
              title: 'وزنة 21',
              subtitle: state.totalWazna21.toStringAsFixed(2),
            ),
            DaftarheaderModel(
              title: 'اجمالي النقدية',
              subtitle: NumberFormatter.format(state.nakdyia),
            ),
            DaftarheaderModel(
              title: 'عدد الحسابات',
              subtitle: state.accountCount.toString(),
            ),
          ];

          return Container(
            decoration: BoxDecoration(
              color: const Color(0xffCC9900), // Amber background color
              borderRadius: BorderRadius.circular(15),
            ),
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  SummaryHeadersDaftaritem(daftarmodel: items[index]),
            ),
          );
        } else if (state is SupplierLoadInProgress) {
          return const Center(child: CustomLoadingIndicator());
        } else if (state is SupplierLoadFailure) {
          return Center(child: Text('Failed to load summary: ${state.error}'));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
