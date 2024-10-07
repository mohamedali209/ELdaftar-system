import 'package:aldafttar/features/Gardview/presentation/manager/cubit/gard_header_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GardHeaderCubit extends Cubit<GardHeaderState> {
  GardHeaderCubit() : super(GardHeaderInitial());

  Future<void> fetchData() async {
    emit(GardHeaderLoading());
    try {
      final docRef = FirebaseFirestore.instance
          .collection('weight')
          .doc('HQWsDzc8ray5gwZp5XgF');
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data() ?? {};

      final total18kWeight = _convertToDouble(data['total18kWeight']);
      final total21kWeight = _convertToDouble(data['total21kWeight']);
      final totalkWeight21 = _convertToDouble(data['totalInventoryWeight21']);
      final totalkKasr21 = _convertToDouble(data['total21kKasr']);
      final totalkKasr18 = _convertToDouble(data['total18kKasr']);
      final sbayekquatatiy = _convertToDouble(data['sabaek_count']);
      final sbayekweight = _convertToDouble(data['sabaek_weight']);
      final totalkasrAll = (totalkKasr18 *6/7) + totalkKasr21;
      final totalinventoryall = (total18kWeight*6/7)+total21kWeight + (sbayekweight *24/21);
      emit(GardHeaderLoaded(
        totalinventoryAll: totalinventoryall,
        totalkKasrAll: totalkasrAll,
        sabekayekQuantity: sbayekquatatiy,
        sbaekayekWeight: sbayekweight,
        totalkKasr21: totalkKasr21,
        totalkKasr18: totalkKasr18,
        totalinventoryWeight21: totalkWeight21,
        total18kWeight: total18kWeight,
        total21kWeight: total21kWeight,
      ));
    } catch (e) {
      emit(GardHeaderError(e.toString()));
    }
  }

  double _convertToDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is num) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }
}
