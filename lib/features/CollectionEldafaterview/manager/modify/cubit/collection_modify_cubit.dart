import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'collection_modify_state.dart';

class CollectionModifyCubit extends Cubit<CollectionModifyState> {
  CollectionModifyCubit()
      : super(const CollectionModifyState(sellingItems: [], buyingItems: []));
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? selectedDate;

  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  void selectDateAndmodifyitem(String year, String month, String day) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not logged in.');
        return;
      }
      final userId = user.uid;

      // Fetch items from Firestore for the selected date
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year)
          .collection(month)
          .doc(day)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        List<Daftarcheckmodel> sellingItems = (data['sellingItems'] as List)
            .map((e) => Daftarcheckmodel.fromFirestore(e))
            .toList();
        List<Daftarcheckmodel> buyingItems = (data['buyingItems'] as List)
            .map((e) => Daftarcheckmodel.fromFirestore(e))
            .toList();

        emit(CollectionModifyState(
          sellingItems: sellingItems,
          buyingItems: buyingItems,
        ));
      } else {
        emit(const CollectionModifyState(sellingItems: [], buyingItems: []));
      }
    } catch (e) {
      debugPrint('Error fetching data for date: $e');
    }
  }

  void modifyItem(
    Daftarcheckmodel modifiedItem, {
    bool isBuyingItem = false,
  }) async {
    try {
      if (selectedDate == null) {
        debugPrint('No date selected. Cannot modify item.');
        return;
      }
      // Fetch current selling and buying items
      Daftarcheckmodel oldSellingItem = state.sellingItems.firstWhere(
        (item) => item.num == modifiedItem.num,
        orElse: () => Daftarcheckmodel(
          tfasel: '',
          num: '0',
          adad: '0',
          gram: '0',
          ayar: '',
          details: '',
          price: '0',
        ),
      );

      Daftarcheckmodel oldBuyingItem = state.buyingItems.firstWhere(
        (item) => item.num == modifiedItem.num,
        orElse: () => Daftarcheckmodel(
          tfasel: '',
          num: '0',
          adad: '0',
          gram: '0',
          ayar: '',
          details: '',
          price: '0',
        ),
      );

      if (!isBuyingItem) {
        // Update selling item
        if (oldSellingItem.num != '0') {
          await updateSellingItem(oldSellingItem, modifiedItem);
        }

        // Update Selling Items List
        List<Daftarcheckmodel> updatedSellingItems = state.sellingItems
            .map((item) => item.num == modifiedItem.num ? modifiedItem : item)
            .toList();

        emit(CollectionModifyState(
          sellingItems: updatedSellingItems,
          buyingItems: state.buyingItems,
        ));
      } else {
        // Update buying item
        if (oldBuyingItem.num != '0') {
          await updateBuyingItem(oldBuyingItem, modifiedItem);
        }

        // Update Buying Items List
        List<Daftarcheckmodel> updatedBuyingItems = state.buyingItems
            .map((item) => item.num == modifiedItem.num ? modifiedItem : item)
            .toList();

        emit(CollectionModifyState(
          sellingItems: state.sellingItems,
          buyingItems: updatedBuyingItems,
        ));
      }

      // Update Firestore with date-specific logic
      await _updateFirestore();
      await _updateTotals();
    } catch (e) {
      debugPrint('Error modifying item: $e');
    }
  }

  Future<void> _updateFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    final String year = DateFormat('yyyy').format(selectedDate!);
    final String month = DateFormat('MM').format(selectedDate!);
    final String day = DateFormat('dd').format(selectedDate!);
    if (user != null) {
      final userId = user.uid;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year)
          .collection(month)
          .doc(day)
          .set({
        'sellingItems':
            state.sellingItems.map((item) => item.toFirestore()).toList(),
        'buyingItems':
            state.buyingItems.map((item) => item.toFirestore()).toList(),
      });
    } else {
      debugPrint('User is not logged in.');
    }
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

    // Check if the item is سبائك
    if (oldBuyingItem.details.contains('سبائك')) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) return; // Ensure the user is authenticated

        String userId = user.uid;

        DocumentSnapshot snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('weight')
            .doc('init')
            .get();

        if (snapshot.exists) {
          // Retrieve current sabaek values
          int currentSabaekCount =
              int.tryParse(snapshot['sabaek_count'] ?? '0') ?? 0;
          double currentSabaekWeight =
              double.tryParse(snapshot['sabaek_weight'] ?? '0.0') ?? 0.0;

          // Calculate new values based on the modified item
          int oldAdad = int.parse(oldBuyingItem.adad);
          double oldGram = double.parse(oldBuyingItem.gram);
          int newAdad = int.parse(modifiedItem.adad);
          double newGram = double.parse(modifiedItem.gram);

          int newSabaekCount = currentSabaekCount - oldAdad + newAdad;
          double newSabaekWeight = currentSabaekWeight - oldGram + newGram;

          // Update Firestore with the new values
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('weight')
              .doc('init')
              .update({
            'sabaek_count': newSabaekCount.toString(),
            'sabaek_weight': newSabaekWeight.toString(),
          });
        }
      } catch (e) {
        debugPrint('Error updating سبائك: $e');
      }
      return; // Exit as سبائك has been handled
    }

    // General Buying Item Update Logic (excluding سبائك)
    if (oldBuyingItem.ayar != modifiedItem.ayar ||
        oldBuyingItem.price != modifiedItem.price ||
        oldBuyingItem.gram != modifiedItem.gram) {
      await _subtractItemGramsFromWeight(oldBuyingItem);
      await _addNewItemGramsToNewAyar(modifiedItem);
    }
  }

  Future<void> updateTotalCash(double priceDifference) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    String userId = user.uid;

    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init')
        .get();

    if (snapshot.exists) {
      double totalCash = double.parse(snapshot['total_cash'] ?? '0.0');
      totalCash += priceDifference;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init')
          .update({
        'total_cash': totalCash.toString(),
      });
    }
  }

// Subtract the old item's grams from inventory (based on Ayar)
  Future<void> _subtractItemGramsFromWeight(Daftarcheckmodel oldItem) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    String userId = user.uid;

    DocumentSnapshot weightSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init')
        .get();

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

      // Ensure no negative values
      if (currentTotal18kKasr < 0) currentTotal18kKasr = 0;
      if (currentTotal21kKasr < 0) currentTotal21kKasr = 0;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init')
          .update({
        'total18kKasr': currentTotal18kKasr.toString(),
        'total21kKasr': currentTotal21kKasr.toString(),
      });
    }
  }

// Add only the new item's grams to the new Ayar inventory
  Future<void> _addNewItemGramsToNewAyar(Daftarcheckmodel newItem) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    String userId = user.uid;

    DocumentSnapshot weightSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init')
        .get();

    if (weightSnapshot.exists) {
      double currentTotal18kKasr =
          double.parse(weightSnapshot['total18kKasr'] ?? '0.0');
      double currentTotal21kKasr =
          double.parse(weightSnapshot['total21kKasr'] ?? '0.0');

      // Add the new item's grams to the respective Ayar
      if (newItem.ayar == '18k') {
        currentTotal18kKasr += double.parse(newItem.gram);
      } else if (newItem.ayar == '21k') {
        currentTotal21kKasr += double.parse(newItem.gram);
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init')
          .update({
        'total18kKasr': currentTotal18kKasr.toString(),
        'total21kKasr': currentTotal21kKasr.toString(),
      });
    }
  }

  Future<void> updateInventory(
      Daftarcheckmodel item, int adadDifference, double gramDifference,
      {bool isAyarChange = false}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    String userId = user.uid;

    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init')
        .get();

    if (snapshot.exists) {
      String itemType =
          _getItemType(item.details); // Helper function to get item type
      bool is18k = item.ayar.contains('18k');

      if (itemType.isNotEmpty) {
        if (itemType == 'سبائك') {
          try {
            int currentSabaekCount =
                int.tryParse(snapshot['sabaek_count'] ?? '0') ?? 0;
            double currentSabaekWeight =
                double.tryParse(snapshot['sabaek_weight'] ?? '0.0') ?? 0.0;

            int newSabaekCount = currentSabaekCount + adadDifference;
            double newSabaekWeight = currentSabaekWeight + gramDifference;

            await _firestore
                .collection('users')
                .doc(userId)
                .collection('weight')
                .doc('init')
                .update({
              'sabaek_count': newSabaekCount.toString(),
              'sabaek_weight': newSabaekWeight.toStringAsFixed(2),
            });
          } catch (e) {
            debugPrint('Error updating سبائك: $e');
          }
          return; // Exit to ensure no further processing for سبائك
        } else if (itemType == 'جنيهات') {
          int currentGnihatCount = int.parse(snapshot['gnihat_count'] ?? '0');
          double currentGnihatWeight =
              double.parse(snapshot['gnihat_weight'] ?? '0.0');

          int newGnihatCount = currentGnihatCount + adadDifference;
          double newGnihatWeight = currentGnihatWeight + gramDifference;
          double total21kWeight =
              double.parse(snapshot['total21kWeight'] ?? '0.0');
          total21kWeight += gramDifference;
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('weight')
              .doc('init')
              .update({
            'total21kWeight': total21kWeight.toString(),
          });
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('weight')
              .doc('init')
              .update({
            'gnihat_count': newGnihatCount.toString(),
            'gnihat_weight': newGnihatWeight.toStringAsFixed(2),
          });
        } else {
          String quantityField =
              '${itemType}_${is18k ? '18k' : '21k'}_quantity';
          String weightField = '${itemType}_${is18k ? '18k' : '21k'}_weight';

          int currentQuantity = int.parse(snapshot[quantityField] ?? '0');
          double currentWeight = double.parse(snapshot[weightField] ?? '0.0');

          int newQuantity = currentQuantity + adadDifference;
          double newWeight = currentWeight + gramDifference;

          await _firestore
              .collection('users')
              .doc(userId)
              .collection('weight')
              .doc('init')
              .update({
            quantityField: newQuantity.toString(),
            weightField: newWeight.toStringAsFixed(2),
          });

          if (is18k) {
            double total18kWeight =
                double.parse(snapshot['total18kWeight'] ?? '0.0');
            total18kWeight += gramDifference;
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('weight')
                .doc('init')
                .update({
              'total18kWeight': total18kWeight.toString(),
            });
          } else {
            double total21kWeight =
                double.parse(snapshot['total21kWeight'] ?? '0.0');
            total21kWeight += gramDifference;
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('weight')
                .doc('init')
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
    if (selectedDate == null) {
      debugPrint('No date selected. Cannot delete item.');
      return;
    }

    try {
      // Fetch the selected date
      final String year = DateFormat('yyyy').format(selectedDate!);
      final String month = DateFormat('MM').format(selectedDate!);
      final String day = DateFormat('dd').format(selectedDate!);

      // Debugging: Log current state and item to delete
      debugPrint('Current selling items: ${state.sellingItems}');
      debugPrint('Current buying items: ${state.buyingItems}');
      debugPrint('Item to delete: ${itemToDelete.toString()}');

      // Clone lists to work with them
      List<Daftarcheckmodel> updatedSellingItems =
          List.from(state.sellingItems);
      List<Daftarcheckmodel> updatedBuyingItems = List.from(state.buyingItems);

      if (state.sellingItems.any((item) => item.num == itemToDelete.num)) {
         updatedSellingItems = state.sellingItems
          .where((item) => item.num != itemToDelete.num)
          .toList();
      updatedSellingItems = _recalculateItemNumbers(updatedSellingItems);

        // Subtract the item's price from total_cash when deleting a selling item
        await _updateCash(itemToDelete, isSellingItem: true);

        // Update inventory when deleting a selling item
        await updateInventory(itemToDelete, int.parse(itemToDelete.adad),
            double.parse(itemToDelete.gram));
      } else if (state.buyingItems.contains(itemToDelete)) {
        updatedBuyingItems = state.buyingItems
          .where((item) => item.num != itemToDelete.num)
          .toList();
      updatedBuyingItems = _recalculateItemNumbers(updatedBuyingItems);

        // Add the item's price to total_cash when deleting a buying item
        await _updateCash(itemToDelete, isSellingItem: false);

        // Subtract grams from total weights when deleting a buying item
        if (itemToDelete.details.contains('سبائك')) {
          // Ensure subtraction for سبائك
          await updateInventory(
            itemToDelete,
            -int.parse(itemToDelete.adad),
            -double.parse(itemToDelete.gram),
          );
        } else {
          // Subtract the grams from total weights for other buying items
          await _subtractItemGramsFromWeight(itemToDelete);
        }
      }

      // Emit the updated state
     emit(state.copyWith(
      sellingItems: updatedSellingItems,
      buyingItems: updatedBuyingItems,
    ));

      // Update Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not logged in.');
        return;
      }
      final userId = user.uid;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year)
          .collection(month)
          .doc(day)
          .update({
        'sellingItems':
            updatedSellingItems.map((e) => e.toFirestore()).toList(),
        'buyingItems': updatedBuyingItems.map((e) => e.toFirestore()).toList(),
      });

      // Update totals
      await _updateTotals();

      debugPrint('Item deleted successfully.');
    } catch (e) {
      debugPrint('Error deleting item: $e');
    }
  }
  List<Daftarcheckmodel> _recalculateItemNumbers(
    List<Daftarcheckmodel> items) {
  return items.asMap().entries.map((entry) {
    final index = entry.key;
    final item = entry.value;
    return item.copyWith(num: (index + 1).toString());
  }).toList();
}

// Helper function to update total_cash based on the item being deleted
  Future<void> _updateCash(Daftarcheckmodel item,
      {required bool isSellingItem}) async {
    // Get the current user ID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle case where the user is not authenticated
      debugPrint('Error: No authenticated user found.');
      return;
    }

    // Access the 'weight' collection under the user's document
    DocumentSnapshot cashSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init')
        .get();

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

      // Update the total_cash in Firestore for the authenticated user
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init')
          .update({
        'total_cash': totalCash.toString(),
      });
    }
  }

  Future<void> _updateTotals() async {
    final String year = DateFormat('yyyy').format(selectedDate!);
    final String month = DateFormat('MM').format(selectedDate!);
    final String day = DateFormat('dd').format(selectedDate!);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
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

    // Update the totals for this user in the Firestore path 'users/{userId}/dailyTransactions/{year}/{month}/{day}'
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('dailyTransactions')
        .doc(year)
        .collection(month)
        .doc(day)
        .update({
      'totalSalePrice': totalSalePrice.toString(),
      'totalBuyingPrice': totalBuyingPrice.toString(),
      'total18kasr': total18kasr.toString(),
      'total21kasr': total21kasr.toString(),
    });
  }
}
