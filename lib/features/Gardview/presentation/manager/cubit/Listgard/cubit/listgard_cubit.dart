import 'package:aldafttar/features/Gardview/presentation/manager/cubit/Listgard/cubit/listgard_state.dart';
import 'package:aldafttar/features/Gardview/presentation/model/row_gard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListGardCubit extends Cubit<ListGardState> {
  ListGardCubit() : super(ListGardInitial());

  Future<void> fetchData() async {
    emit(ListGardLoading());

    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF');
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data() ?? {};

      List<Gardmodel> items = [];

      List<String> categories = [
        'خواتم',
        'دبل',
        'سلاسل',
        'حلقان',
        'انسيالات',
        'اساور',
        'تعاليق',
        'كوليهات',
        'غوايش',
        'جنيهات',
      ];

      for (String category in categories) {
        final num21 = category == 'جنيهات'
            ? data['gnihat_count'] ?? '0'  // Use gnihat_count for num21 in جنيهات
            : data['${category}_21k_quantity'] ?? '0';
        final num18 = category == 'جنيهات'
            ? '0'  // Set to 0 for جنيهات
            : data['${category}_18k_quantity'] ?? '0';
        final wazn18 = category == 'جنيهات'
            ? '0'  // Set to 0 for جنيهات
            : data['${category}_18k_weight'] ?? '0';
        final wazn21 = category == 'جنيهات'
            ? data['gnihat_weight'] ?? '0'  // Use gnihat_weight for wazn21 in جنيهات
            : data['${category}_21k_weight'] ?? '0';

        items.add(
          Gardmodel(
            no3: category,
            num21: num21,
            num18: num18,
            wazn18: wazn18,
            wazn21: wazn21,
          ),
        );
      }

      emit(ListGardLoaded(items));
    } catch (e) {
      emit(ListGardError('Error fetching data: ${e.toString()}'));
    }
  }
}
