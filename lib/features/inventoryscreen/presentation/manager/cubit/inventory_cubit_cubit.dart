import 'package:aldafttar/features/inventoryscreen/presentation/manager/cubit/inventory_cubit_state.dart' as state;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryCubit extends Cubit<state.InventoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InventoryCubit() : super(state.InventoryInitial()) {
    _loadDataFromFirestore();
  }

  final Map<String, String> _controllers = {};

  void _loadDataFromFirestore() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data.forEach((key, value) {
          _controllers[key] = value.toString();
        });
        emit(state.InventoryUpdated(_controllers));
      }
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  void setControllerValue(String key, String value) {
    _controllers[key] = value;
    emit(state.InventoryUpdated(_controllers));
  }

  void calculateTotals() {
    double total18kWeight = 0.0;
    double total21kWeight = 0.0;
    double total18kKasr = 0.0;
    double total21kKasr = 0.0;
    double totalCash = double.tryParse(_controllers['total_cash'] ?? '') ?? 0.0;

    for (String type in [
      'خواتم',
      'دبل',
      'محابس',
      'انسيالات',
      'غوايش',
      'حلقان',
      'تعاليق',
      'كوليهات',
      'سلاسل',
      'اساور'
    ]) {
      double weight18k =
          double.tryParse(_controllers['${type}_18k_weight'] ?? '') ?? 0.0;
      double weight21k =
          double.tryParse(_controllers['${type}_21k_weight'] ?? '') ?? 0.0;
      total18kWeight += weight18k;
      total21kWeight += weight21k;
    }

    total18kKasr = double.tryParse(_controllers['18k_kasr'] ?? '') ?? 0.0;
    total21kKasr = double.tryParse(_controllers['21k_kasr'] ?? '') ?? 0.0;

    double sabekatQuantity =
        double.tryParse(_controllers['sabaek_count'] ?? '') ?? 0.0;
    double sabekatWeight =
        double.tryParse(_controllers['sabaek_weight'] ?? '') ?? 0.0;
    double ginehatQuantity =
        double.tryParse(_controllers['gnihat_count'] ?? '') ?? 0.0;
    double ginehatWeight =
        double.tryParse(_controllers['gnihat_weight'] ?? '') ?? 0.0;

    double totalInventoryWeight21 = (total18kWeight * 6 / 7) + total21kWeight;

    _updateDataToFirestore(
      total18kWeight,
      total21kWeight,
      total18kKasr,
      total21kKasr,
      totalCash,
      totalInventoryWeight21,
      sabekatQuantity,
      sabekatWeight,
      ginehatQuantity,
      ginehatWeight,
    );

    emit(
      state.InventoryTotalsCalculated(
        total18kWeight,
        total21kWeight,
        total18kKasr,
        total21kKasr,
        totalCash,
        totalInventoryWeight21,
        sabekatQuantity,
        sabekatWeight,
        ginehatQuantity,
        ginehatWeight,
      ),
    );
  }

  Future<void> _updateDataToFirestore(
    double total18kWeight,
    double total21kWeight,
    double total18kKasr,
    double total21kKasr,
    double totalCash,
    double totalInventoryWeight21,
    double sabekatQuantity,
    double sabekatWeight,
    double ginehatQuantity,
    double ginehatWeight,
  ) async {
    try {
      await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').update({
        'total18kWeight': total18kWeight.toStringAsFixed(2),
        'total21kWeight': total21kWeight.toStringAsFixed(2),
        'total18kKasr': total18kKasr.toStringAsFixed(2),
        'total21kKasr': total21kKasr.toStringAsFixed(2),
        'total_cash': totalCash.toStringAsFixed(0),
        'totalInventoryWeight21': totalInventoryWeight21.toStringAsFixed(2),
        'sabaek_count': sabekatQuantity.toStringAsFixed(0),
        'sabaek_weight': sabekatWeight.toStringAsFixed(2),
        'gnihat_count': ginehatQuantity.toStringAsFixed(0),
        'gnihat_weight': ginehatWeight.toStringAsFixed(2),
        // Add fields for the new categories
        for (String type in [
          'خواتم',
          'دبل',
          'محابس',
          'انسيالات',
          'غوايش',
          'حلقان',
          'تعاليق',
          'كوليهات',
          'سلاسل',
          'اساور'
        ]) ...{
          '${type}_18k_quantity': double.tryParse(_controllers['${type}_18k_quantity'] ?? '')?.toStringAsFixed(0) ?? '0',
          '${type}_21k_quantity': double.tryParse(_controllers['${type}_21k_quantity'] ?? '')?.toStringAsFixed(0) ?? '0',
          '${type}_18k_weight': double.tryParse(_controllers['${type}_18k_weight'] ?? '')?.toStringAsFixed(2) ?? '0',
          '${type}_21k_weight': double.tryParse(_controllers['${type}_21k_weight'] ?? '')?.toStringAsFixed(2) ?? '0',
        },
      });
      print('Data successfully updated to Firestore');
    } catch (e) {
      print('Failed to update data: $e');
    }
  }
}