import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'modifying_state.dart';

class ModifyingCubit extends Cubit<ModifyingState> {
  ModifyingCubit()
      : super(const ModifyingState(sellingItems: [], buyingItems: []));
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void modifyItem(Daftarcheckmodel modifiedItem,
      {bool isBuyingItem = false}) async {
    // Fetch current selling and buying items
    Daftarcheckmodel oldSellingItem = state.sellingItems.firstWhere(
      (item) => item.num == modifiedItem.num,
      orElse: () => Daftarcheckmodel(
        tfasel: '',
          num: '0', adad: '0', gram: '0', ayar: '', details: '', price: '0'),
    );

    Daftarcheckmodel oldBuyingItem = state.buyingItems.firstWhere(
      (item) => item.num == modifiedItem.num,
      orElse: () => Daftarcheckmodel(
        tfasel: '',
          num: '0', adad: '0', gram: '0', ayar: '', details: '', price: '0'),
    );

    // Update logic based on whether it's a buying or selling item
    if (!isBuyingItem) {
      // Update Selling Item logic
      if (oldSellingItem.num != '0') {
        await updateSellingItem(oldSellingItem, modifiedItem);
      }

      // Update Selling Items List
      List<Daftarcheckmodel> updatedSellingItems = state.sellingItems
          .map(
            (item) => item.num == modifiedItem.num ? modifiedItem : item,
          )
          .toList();

      emit(ModifyingState(
        sellingItems: updatedSellingItems,
        buyingItems: state.buyingItems, // Do not modify buying items
      ));
    } else {
      // Update Buying Item logic
      if (oldBuyingItem.num != '0') {
        await updateBuyingItem(oldBuyingItem, modifiedItem);
      }

      // Update Buying Items List
      List<Daftarcheckmodel> updatedBuyingItems = state.buyingItems
          .map(
            (item) => item.num == modifiedItem.num ? modifiedItem : item,
          )
          .toList();

      emit(ModifyingState(
        sellingItems: state.sellingItems, // Do not modify selling items
        buyingItems: updatedBuyingItems,
      ));
    }

    // Update Firestore and totals
    await _updateFirestore();
    await _updateTotals();
  }

  Future<void> updateSellingItem(
      Daftarcheckmodel oldItem, Daftarcheckmodel modifiedItem) async {
    // Calculate price difference and update total_cash
    double oldPrice = double.parse(oldItem.price);
    double newPrice = double.parse(modifiedItem.price);
    double priceDifference = newPrice - oldPrice;
    await updateTotalCash(priceDifference);

    // Selling Item Update Logic (including price)
    if (oldItem.ayar != modifiedItem.ayar ||
        oldItem.price != modifiedItem.price) {
      await updateInventory(
          oldItem, int.parse(oldItem.adad), double.parse(oldItem.gram));
      await updateInventory(modifiedItem, -int.parse(modifiedItem.adad),
          -double.parse(modifiedItem.gram));
    } else {
      int adadDifference =
          int.parse(oldItem.adad) - int.parse(modifiedItem.adad);
      double gramDifference =
          double.parse(oldItem.gram) - double.parse(modifiedItem.gram);

      if (adadDifference != 0 || gramDifference != 0) {
        await updateInventory(modifiedItem, adadDifference, gramDifference);
      }
    }
  }

  Future<void> updateBuyingItem(
      Daftarcheckmodel oldBuyingItem, Daftarcheckmodel modifiedItem) async {
    // Calculate price difference and update total_cash based on the logic
    double oldPrice = double.parse(oldBuyingItem.price);
    double newPrice = double.parse(modifiedItem.price);
    double priceDifference = newPrice - oldPrice; // Difference for buying items

    // If the price increases, subtract the difference from total_cash
    if (priceDifference > 0) {
      await updateTotalCash(
          -priceDifference); // Subtract the difference from total_cash
    }
    // If the price decreases, add the difference to total_cash
    else if (priceDifference < 0) {
      await updateTotalCash(
          priceDifference.abs()); // Add the absolute difference to total_cash
    }

    // Buying Item Update Logic (including price)
    if (oldBuyingItem.ayar != modifiedItem.ayar ||
        oldBuyingItem.price != modifiedItem.price) {
      await _subtractItemGramsFromWeight(oldBuyingItem);
      await _addNewItemGramsToNewAyar(modifiedItem);
    } else {
      int adadDifference =
          int.parse(oldBuyingItem.adad) - int.parse(modifiedItem.adad);
      double gramDifference =
          double.parse(oldBuyingItem.gram) - double.parse(modifiedItem.gram);

      if (adadDifference != 0 || gramDifference != 0) {
        await updateInventory(modifiedItem, adadDifference, gramDifference);
      }
    }
  }

  Future<void> updateTotalCash(double priceDifference) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').get();

    if (snapshot.exists) {
      double totalCash = double.parse(snapshot['total_cash'] ?? '0.0');
      totalCash += priceDifference;

      await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').update({
        'total_cash': totalCash.toString(),
      });
    }
  }

// Subtract the old item's grams from inventory (based on Ayar)
  Future<void> _subtractItemGramsFromWeight(Daftarcheckmodel oldItem) async {
    DocumentSnapshot weightSnapshot =
        await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').get();
    if (weightSnapshot.exists) {
      double currentTotal18kKasr =
          double.parse(weightSnapshot['total18kKasr'] ?? '0.0');
      double currentTotal21kKasr =
          double.parse(weightSnapshot['total21kKasr'] ?? '0.0');

      // Subtract the old item's grams from the respective Ayar
      if (oldItem.ayar == '18k') {
        currentTotal18kKasr -= double.parse(oldItem.gram);
      } else if (oldItem.ayar == '21k') {
        currentTotal21kKasr -= double.parse(oldItem.gram);
      }

      // Ensure we don't get negative values
      if (currentTotal18kKasr < 0) currentTotal18kKasr = 0;
      if (currentTotal21kKasr < 0) currentTotal21kKasr = 0;

      // Update the inventory in Firestore
      await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').update({
        'total18kKasr': currentTotal18kKasr.toString(),
        'total21kKasr': currentTotal21kKasr.toString(),
      });
    }
  }

// Add only the new item's grams to the new Ayar inventory
  Future<void> _addNewItemGramsToNewAyar(Daftarcheckmodel newItem) async {
    DocumentSnapshot weightSnapshot =
        await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').get();
    if (weightSnapshot.exists) {
      double currentTotal18kKasr =
          double.parse(weightSnapshot['total18kKasr'] ?? '0.0');
      double currentTotal21kKasr =
          double.parse(weightSnapshot['total21kKasr'] ?? '0.0');

      // Add only the new item's grams to the respective Ayar
      if (newItem.ayar == '18k') {
        currentTotal18kKasr += double.parse(newItem.gram);
      } else if (newItem.ayar == '21k') {
        currentTotal21kKasr += double.parse(newItem.gram);
      }

      // Update the inventory in Firestore
      await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').update({
        'total18kKasr': currentTotal18kKasr.toString(),
        'total21kKasr': currentTotal21kKasr.toString(),
      });
    }
  }

  Future<void> updateInventory(
      Daftarcheckmodel item, int adadDifference, double gramDifference,
      {bool isAyarChange = false}) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').get();

    if (snapshot.exists) {
      String itemType =
          _getItemType(item.details); // Helper function to get item type
      bool is18k = item.ayar.contains('18k');
      bool is24k = item.ayar.contains('24k'); // For سبائك (Sabaek)

      if (itemType.isNotEmpty) {
        if (itemType == 'سبائك' && is24k) {
          // Handle سبائك (Sabaek) separately
          int currentSabaekCount = int.parse(snapshot['sabaek_count'] ?? '0');
          double currentSabaekWeight =
              double.parse(snapshot['sabaek_weight'] ?? '0.0');

          int newSabaekCount = currentSabaekCount + adadDifference;
          double newSabaekWeight = currentSabaekWeight + gramDifference;

          // Update سبائك count and weight
          await _firestore
              .collection('weight')
              .doc('HQWsDzc8ray5gwZp5XgF')
              .update({
            'sabaek_count': newSabaekCount.toString(),
            'sabaek_weight': newSabaekWeight.toString(),
          });
        } else if (itemType == 'جنيهات') {
          // Handle جنيهات separately
          int currentGnihatCount = int.parse(snapshot['gnihat_count'] ?? '0');
          double currentGnihatWeight =
              double.parse(snapshot['gnihat_weight'] ?? '0.0');

          int newGnihatCount = currentGnihatCount + adadDifference;
          double newGnihatWeight = currentGnihatWeight + gramDifference;

          // Update جنيهات count and weight
          await _firestore
              .collection('weight')
              .doc('HQWsDzc8ray5gwZp5XgF')
              .update({
            'gnihat_count': newGnihatCount.toString(),
            'gnihat_weight': newGnihatWeight.toString(),
          });
        } else {
          // Handle other item types (18k and 21k)
          String quantityField =
              '${itemType}_${is18k ? '18k' : '21k'}_quantity';
          String weightField = '${itemType}_${is18k ? '18k' : '21k'}_weight';

          int currentQuantity = int.parse(snapshot[quantityField] ?? '0');
          double currentWeight = double.parse(snapshot[weightField] ?? '0.0');

          // Only apply differences, not the total values
          int newQuantity = currentQuantity + adadDifference;
          double newWeight = currentWeight + gramDifference;

          // Ensure you're not multiplying or doubling the values unnecessarily
          await _firestore
              .collection('weight')
              .doc('HQWsDzc8ray5gwZp5XgF')
              .update({
            quantityField: newQuantity.toString(),
            weightField: newWeight.toString(),
          });

          // Update the total weight fields (total18kWeight or total21kWeight) only if needed
          if (is18k) {
            double total18kWeight =
                double.parse(snapshot['total18kWeight'] ?? '0.0');
            total18kWeight += gramDifference; // Only add the difference
            await _firestore
                .collection('weight')
                .doc('HQWsDzc8ray5gwZp5XgF')
                .update({
              'total18kWeight': total18kWeight.toString(),
            });
          } else {
            double total21kWeight =
                double.parse(snapshot['total21kWeight'] ?? '0.0');
            total21kWeight += gramDifference; // Only add the difference
            await _firestore
                .collection('weight')
                .doc('HQWsDzc8ray5gwZp5XgF')
                .update({
              'total21kWeight': total21kWeight.toString(),
            });
          }
        }
      }
    }
  }

// Helper function to determine the item type based on details
  String _getItemType(String details) {
    if (details.contains('خاتم')) return 'خواتم';
    if (details.contains('اسورة')) return 'اساور';
    if (details.contains('محابس')) return 'محابس';
    if (details.contains('دبلة')) return 'دبل';
    if (details.contains('سلسلة')) return 'سلاسل';
    if (details.contains('غوايش')) return 'غوايش';
    if (details.contains('كوليه')) return 'كوليهات';
    if (details.contains('حلق')) return 'حلقان';
    if (details.contains('انسيال')) return 'انسيالات';
    if (details.contains('تعليقة')) return 'تعاليق';
    if (details.contains('سبائك')) return 'سبائك'; // سبائك item type
    if (details.contains('جنيه')) return 'جنيهات'; // Added جنيهات item type
    return '';
  }

  void deleteItem(Daftarcheckmodel itemToDelete) async {
    List<Daftarcheckmodel> updatedSellingItems = List.from(state.sellingItems);
    List<Daftarcheckmodel> updatedBuyingItems = List.from(state.buyingItems);

    if (state.sellingItems.contains(itemToDelete)) {
      updatedSellingItems = state.sellingItems
          .where((item) => item.num != itemToDelete.num)
          .toList();

      // Subtract the item's price from total_cash when deleting a selling item
      await _updateCash(itemToDelete, isSellingItem: true);

      // Update inventory when deleting a selling item
      await updateInventory(itemToDelete, int.parse(itemToDelete.adad),
          double.parse(itemToDelete.gram));
    } else if (state.buyingItems.contains(itemToDelete)) {
      updatedBuyingItems = state.buyingItems
          .where((item) => item.num != itemToDelete.num)
          .toList();

      // Add the item's price to total_cash when deleting a buying item
      await _updateCash(itemToDelete, isSellingItem: false);

      // Subtract the grams from total18kasr or total21kasr when deleting a buying item
      await _subtractItemGramsFromWeight(itemToDelete);
    }

    // Emit the new state with updated lists
    emit(ModifyingState(
      sellingItems: updatedSellingItems,
      buyingItems: updatedBuyingItems,
    ));

    await _updateFirestore();
    await _updateTotals();
  }

// Helper function to update total_cash based on the item being deleted
  Future<void> _updateCash(Daftarcheckmodel item,
      {required bool isSellingItem}) async {
    DocumentSnapshot cashSnapshot =
        await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').get();

    if (cashSnapshot.exists) {
      double totalCash = double.parse(cashSnapshot['total_cash'] ?? '0.0');
      double itemPrice = double.parse(item.price);

      if (isSellingItem) {
        // Subtract from total_cash if it's a selling item
        totalCash -= itemPrice;
      } else {
        // Add to total_cash if it's a buying item
        totalCash += itemPrice;
      }

      // Update the total_cash in Firestore
      await _firestore.collection('weight').doc('HQWsDzc8ray5gwZp5XgF').update({
        'total_cash': totalCash.toString(),
      });
    }
  }
   Future<void> _updateTotals() async {
    int totalSalePrice = 0;
    int totalBuyingPrice = 0;
    double total18kasr = 0.0;
    double total21kasr = 0.0;

    for (var item in state.sellingItems) {
      totalSalePrice += int.parse(item.price);
    }

    for (var item in state.buyingItems) {
      totalBuyingPrice += int.parse(item.price);
      if (item.ayar == '18k') {
        total18kasr += double.parse(item.gram);
      } else {
        total21kasr += double.parse(item.gram);
      }
    }

    await _firestore.collection('dailyTransactions').doc('today').update({
      'totalSalePrice': totalSalePrice.toString(),
      'totalBuyingPrice': totalBuyingPrice.toString(),
      'total18kasr': total18kasr.toString(),
      'total21kasr': total21kasr.toString(),
    });
  }
   Future<void> _updateFirestore() async {
    await _firestore.collection('dailyTransactions').doc('today').set({
      'sellingItems':
          state.sellingItems.map((item) => item.toFirestore()).toList(),
      'buyingItems':
          state.buyingItems.map((item) => item.toFirestore()).toList(),
    });
  }
}
