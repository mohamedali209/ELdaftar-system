import 'dart:async';
import 'package:aldafttar/features/Gardview/presentation/manager/cubit/gard_header_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GardHeaderCubit extends Cubit<GardHeaderState> {
  GardHeaderCubit() : super(GardHeaderInitial());
      final auth = FirebaseAuth.instance;

  // To listen for real-time updates
  StreamSubscription? _subscription;

  // Stream Firestore data in real-time
  void fetchData() async {
    emit(GardHeaderLoading());

    try {
      final User? user = auth.currentUser;

      if (user == null) {
        emit(GardHeaderError('User not authenticated'));
        return;
      }

      final userId = user.uid;
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init'); // Update this based on your Firestore structure

      _subscription = docRef.snapshots().listen((docSnapshot) {
        if (!docSnapshot.exists) {
          emit(GardHeaderError('Document does not exist'));
          return;
        }

        final data = docSnapshot.data() ?? {};

        final total18kWeight = _convertToDouble(data['total18kWeight']);
        final total21kWeight = _convertToDouble(data['total21kWeight']);
        final totalkWeight21 = _convertToDouble(data['totalInventoryWeight21']);
        final totalkKasr21 = _convertToDouble(data['total21kKasr']);
        final totalkKasr18 = _convertToDouble(data['total18kKasr']);
        final sbayekquatatiy = _convertToDouble(data['sabaek_count']);
        final sbayekweight = _convertToDouble(data['sabaek_weight']);
        final totalkasrAll = (totalkKasr18 * 6 / 7) + totalkKasr21;
        final totalinventoryall =
            (total18kWeight * 6 / 7) + total21kWeight + (sbayekweight * 24 / 21);

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
      });
    } catch (e) {
      emit(GardHeaderError('Error streaming data: ${e.toString()}'));
    }
  }

  // Dispose of the stream when the cubit is no longer needed
  @override
  Future<void> close() {
    _subscription?.cancel(); // Cancel the Firestore stream subscription
    return super.close();
  }

  // Helper method to convert values to double
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
