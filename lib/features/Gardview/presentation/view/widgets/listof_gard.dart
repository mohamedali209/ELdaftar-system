import 'package:aldafttar/features/Gardview/presentation/manager/cubit/Listgard/cubit/listgard_cubit.dart';
import 'package:aldafttar/features/Gardview/presentation/manager/cubit/Listgard/cubit/listgard_state.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/rowof_gard.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Listgard extends StatelessWidget {
  const Listgard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListGardCubit()..fetchData(),
      child: BlocBuilder<ListGardCubit, ListGardState>(
        builder: (context, state) {
          if (state is ListGardLoading) {
            return const Center(child: CustomLoadingIndicator());
          } else if (state is ListGardError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ListGardLoaded) {
            final items = state.items;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Rowofgard(gardmodel: item),
                  );
                }).toList(),
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
