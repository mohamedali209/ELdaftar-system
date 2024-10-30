import 'dart:async';

import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/employeesdftar/manager/cubit/employeesitem_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeesitemCubit extends Cubit<EmployeesitemState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _subscription;

  EmployeesitemCubit()
      : super(const EmployeesitemState(sellingItems: [], buyingItems: [])) {
    fetchInitialData();
  }

  void fetchInitialData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userId = user.uid;

        // Step 1: Fetch shopId from employees collection using userId
        DocumentSnapshot employeeDoc =
            await _firestore.collection('employees').doc(userId).get();

        if (employeeDoc.exists && employeeDoc.data() != null) {
          final data = employeeDoc.data() as Map<String, dynamic>?;
          final shopId = data?['shopId'];

          // Step 2: Get the current date components (year, month, day)
          final now = DateTime.now();
          final String year = DateFormat('yyyy').format(now);
          final String month = DateFormat('MM').format(now);
          final String day = DateFormat('dd').format(now);

          // Step 3: Stream real-time updates for the shop's daily transactions in the users collection
          _subscription = _firestore
              .collection(
                  'users') // Assuming daily transactions are stored in the users collection
              .doc(shopId) // Accessing the user document using shopId
              .collection('dailyTransactions')
              .doc(year)
              .collection(month)
              .doc(day)
              .snapshots()
              .listen((snapshot) {
            if (snapshot.exists) {
              List<Daftarcheckmodel> sellingItems = [];
              List<Daftarcheckmodel> buyingItems = [];

              if (snapshot.data() != null) {
                if (snapshot['sellingItems'] != null) {
                  sellingItems = (snapshot['sellingItems'] as List)
                      .map((item) => Daftarcheckmodel.fromFirestore(item))
                      .toList();
                }
                if (snapshot['buyingItems'] != null) {
                  buyingItems = (snapshot['buyingItems'] as List)
                      .map((item) => Daftarcheckmodel.fromFirestore(item))
                      .toList();
                }
              }

              emit(EmployeesitemState(
                  sellingItems: sellingItems, buyingItems: buyingItems));
            } else {
              emit(const EmployeesitemState(sellingItems: [], buyingItems: []));
            }
          }, onError: (error) {
            debugPrint('Error fetching data: $error');
          });
        } else {
          emit(const EmployeesitemState(sellingItems: [], buyingItems: []));
        }
      } else {
        debugPrint('User is not logged in.');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Future<void> close() {
    _subscription
        ?.cancel(); // Cancel the stream subscription to prevent memory leaks
    return super.close();
  }

  void addSellingItem(Daftarcheckmodel newItem) async {
    final nextNum = (state.sellingItems.length + 1).toString();
    final newItemWithNum = newItem.copyWith(num: nextNum);

    emit(EmployeesitemState(
      sellingItems: List.from(state.sellingItems)..add(newItemWithNum),
      buyingItems: state.buyingItems,
    ));

    try {
      await _updateFirestore();
      await _subtractFromInventory(newItemWithNum);
      await _updateTotals();
      await _updateTotalCash(double.tryParse(newItemWithNum.price) ?? 0,
          add: true);
    } catch (e) {
      debugPrint('Error adding selling item: $e');
    }
  }
void addBuyingItem(Daftarcheckmodel newItem) async {
    final nextNum = (state.buyingItems.length + 1).toString();
    final newItemWithNum = newItem.copyWith(num: nextNum);

    emit(EmployeesitemState(
      sellingItems: state.sellingItems,
      buyingItems: List.from(state.buyingItems)..add(newItemWithNum),
    ));

    try {
      // Execute all async tasks concurrently for better performance
      await _updateFirestore();
      await _addItemGramsToWeight(newItemWithNum); // Update weight collection
      await _updateTotals();
      await _updateTotalCash(double.tryParse(newItemWithNum.price) ?? 0,
          add: false);
    } catch (e) {
      debugPrint('Error adding buying item: $e');
    }
  }
  Future<void> _addItemGramsToWeight(Daftarcheckmodel newItem) async {
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userId = user.uid;

    // Fetch the shopId from the employees collection
    DocumentSnapshot employeeSnapshot = await _firestore
        .collection('employees')
        .doc(userId)
        .get();

    if (employeeSnapshot.exists && employeeSnapshot.data() != null) {
      final data = employeeSnapshot.data() as Map<String, dynamic>;
      final shopId = data['shopId']; // Fetch the shopId

      // Fetch current totals from the user's weight collection using shopId
      DocumentSnapshot weightSnapshot = await _firestore
          .collection('users')
          .doc(shopId) // Use shopId here
          .collection('weight')
          .doc('init')
          .get();

      if (weightSnapshot.exists) {
        double currentTotal18kKasr =
            double.parse(weightSnapshot['total18kKasr'] ?? '0.0');
        double currentTotal21kKasr =
            double.parse(weightSnapshot['total21kKasr'] ?? '0.0');
        double currentTotal24kKasr =
            double.parse(weightSnapshot['sabaek_weight'] ?? '0.0');
        double currentTotal24kKasrQuantity =
            double.parse(weightSnapshot['sabaek_count'] ?? '0.0');

        // Add only the grams of the new item to the respective field based on ayar (18k, 21k, or 24k)
        if (newItem.ayar == '18k') {
          currentTotal18kKasr += double.parse(newItem.gram);
        } else if (newItem.ayar == '21k') {
          currentTotal21kKasr += double.parse(newItem.gram);
        } else if (newItem.ayar == '24k') {
          currentTotal24kKasr += double.parse(newItem.gram);
          currentTotal24kKasrQuantity += int.parse(newItem.adad);
        }

        // Update the weight collection for the shop with the new values
        await _firestore
            .collection('users')
            .doc(shopId) // Use shopId here
            .collection('weight')
            .doc('init')
            .update({
          'total18kKasr': currentTotal18kKasr.toString(),
          'total21kKasr': currentTotal21kKasr.toString(),
          'sabaek_weight': currentTotal24kKasr.toString(),
          'sabaek_count': currentTotal24kKasrQuantity.toString(),
        });
      }
    } else {
      debugPrint('Employee document does not exist or is empty.');
    }
  } else {
    debugPrint('User is not logged in.');
    // Handle the case when the user is not logged in
  }
}

  Future<void> _updateFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;

      try {
        // Step 1: Fetch shopId from employees collection using userId
        DocumentSnapshot employeeDoc =
            await _firestore.collection('employees').doc(userId).get();

        if (employeeDoc.exists && employeeDoc.data() != null) {
          final data = employeeDoc.data() as Map<String, dynamic>;
          final shopId = data['shopId']; // Fetching shopId

          // Get the current date components (year, month, day)
          final now = DateTime.now();
          final String year = DateFormat('yyyy').format(now);
          final String month = DateFormat('MM').format(now);
          final String day = DateFormat('dd').format(now);

          // Step 2: Update the shop's daily transactions for the specific day
          await _firestore
              .collection('users')
              .doc(shopId) // Use shopId instead of userId
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

          debugPrint('Firestore updated successfully for shopId: $shopId');
        } else {
          debugPrint('Employee document does not exist or has no data.');
        }
      } catch (e) {
        debugPrint('Error updating Firestore: $e');
      }
    } else {
      debugPrint('User is not logged in.');
    }
  }

  Future<void> _subtractFromInventory(Daftarcheckmodel item) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Use the user's ID to fetch shopId from the employees collection
      final userId = user.uid;

      try {
        // Fetch the employee document using the user's ID
        DocumentSnapshot employeeDoc =
            await _firestore.collection('employees').doc(userId).get();

        if (employeeDoc.exists && employeeDoc.data() != null) {
          final data = employeeDoc.data() as Map<String, dynamic>;
          final shopId = data['shopId']; // Fetching shopId

          // Fetch the weight document for the specific shop
          DocumentSnapshot snapshot = await _firestore
              .collection('users')
              .doc(shopId) // Use shopId here
              .collection('weight')
              .doc('init')
              .get();

          if (snapshot.exists) {
            String itemType = '';
            bool is18k = item.ayar.contains('18k');
            bool is24k = item.ayar.contains('24k'); // For سبائك (24k gold)

            // Determine the item type based on the details of the item
            if (item.details.contains('خاتم')) {
              itemType = 'خواتم';
            } else if (item.details.contains('اسورة')) {
              itemType = 'اساور';
            } else if (item.details.contains('محبس')) {
              itemType = 'محابس';
            } else if (item.details.contains('دبلة')) {
              itemType = 'دبل';
            } else if (item.details.contains('سلسلة')) {
              itemType = 'سلاسل';
            } else if (item.details.contains('غوايش')) {
              itemType = 'غوايش';
            } else if (item.details.contains('كوليه')) {
              itemType = 'كوليهات';
            } else if (item.details.contains('حلق')) {
              itemType = 'حلقان';
            } else if (item.details.contains('انسيال')) {
              itemType = 'انسيالات';
            } else if (item.details.contains('تعليقة')) {
              itemType = 'تعاليق';
            } else if (item.details.contains('سبائك')) {
              itemType = 'سبائك';
            } else if (item.details.contains('جنيهات')) {
              itemType = 'جنيهات';
            } else if (item.details.contains('كسر')) {
              itemType = 'كسر';
            }

            // Proceed if the item type is valid
            if (itemType.isNotEmpty) {
              if (itemType == 'سبائك' && is24k) {
                // Handle the case for سبائك (24k gold)
                int currentSabaekCount = int.parse(snapshot['sabaek_count']);
                double currentSabaekWeight =
                    double.parse(snapshot['sabaek_weight']);

                int newSabaekCount = currentSabaekCount - int.parse(item.adad);
                double newSabaekWeight =
                    currentSabaekWeight - double.parse(item.gram);

                // Update the سبائك fields (count and weight)
                await _firestore
                    .collection('users')
                    .doc(shopId) // Use shopId here
                    .collection('weight')
                    .doc('init')
                    .update({
                  'sabaek_count': newSabaekCount.toString(),
                  'sabaek_weight': newSabaekWeight.toString(),
                });
              } else if (itemType == 'كسر') {
                // Handle the case for كسر (18k and 21k)
                if (is18k) {
                  double total18kKasr = double.parse(snapshot['total18kKasr']);
                  total18kKasr -= double.parse(item.gram);

                  // Update total18kKasr in Firestore
                  await _firestore
                      .collection('users')
                      .doc(shopId) // Use shopId here
                      .collection('weight')
                      .doc('init')
                      .update({
                    'total18kKasr': total18kKasr.toString(),
                  });
                } else {
                  double total21kKasr = double.parse(snapshot['total21kKasr']);
                  total21kKasr -= double.parse(item.gram);

                  // Update total21kKasr in Firestore
                  await _firestore
                      .collection('users')
                      .doc(shopId) // Use shopId here
                      .collection('weight')
                      .doc('init')
                      .update({
                    'total21kKasr': total21kKasr.toString(),
                  });
                }
              } else if (itemType == 'جنيهات') {
                // Handle the case for جنيهات
                int currentGnihatCount = int.parse(snapshot['gnihat_count']);
                double currentGnihatWeight =
                    double.parse(snapshot['gnihat_weight']);

                int newGnihatCount = currentGnihatCount - int.parse(item.adad);
                double newGnihatWeight =
                    currentGnihatWeight - double.parse(item.gram);

                // Update the جنيهات fields (count and weight)
                await _firestore
                    .collection('users')
                    .doc(shopId) // Use shopId here
                    .collection('weight')
                    .doc('init')
                    .update({
                  'gnihat_count': newGnihatCount.toString(),
                  'gnihat_weight': newGnihatWeight.toString(),
                });

                // Subtract جنيهات weight from total21kWeight
                double total21kWeight =
                    double.parse(snapshot['total21kWeight']);
                total21kWeight -= double.parse(item.gram);

                // Update total21kWeight in Firestore
                await _firestore
                    .collection('users')
                    .doc(shopId) // Use shopId here
                    .collection('weight')
                    .doc('init')
                    .update({
                  'total21kWeight': total21kWeight.toString(),
                });
              } else {
                // Handle other item types (18k and 21k)
                String quantityField =
                    '${itemType}_${is18k ? '18k' : '21k'}_quantity';
                String weightField =
                    '${itemType}_${is18k ? '18k' : '21k'}_weight';

                int currentQuantity = int.parse(snapshot[quantityField]);
                double currentWeight = double.parse(snapshot[weightField]);

                int newQuantity = currentQuantity - int.parse(item.adad);
                double newWeight = currentWeight - double.parse(item.gram);

                // Update the specific item fields (quantity and weight)
                await _firestore
                    .collection('users')
                    .doc(shopId) // Use shopId here
                    .collection('weight')
                    .doc('init')
                    .update({
                  quantityField: newQuantity.toString(),
                  weightField: newWeight.toString(),
                });

                // Update the total weight fields
                if (is18k) {
                  double total18kWeight =
                      double.parse(snapshot['total18kWeight']);
                  total18kWeight -= double.parse(item.gram);
                  await _firestore
                      .collection('users')
                      .doc(shopId) // Use shopId here
                      .collection('weight')
                      .doc('init')
                      .update({
                    'total18kWeight': total18kWeight.toString(),
                  });
                } else {
                  double total21kWeight =
                      double.parse(snapshot['total21kWeight']);
                  total21kWeight -= double.parse(item.gram);
                  await _firestore
                      .collection('users')
                      .doc(shopId) // Use shopId here
                      .collection('weight')
                      .doc('init')
                      .update({
                    'total21kWeight': total21kWeight.toString(),
                  });
                }
              }
            }
          }
        } else {
          debugPrint('Employee document does not exist or has no data.');
        }
      } catch (e) {
        debugPrint('User is not logged in.');
        // Handle case when user is not logged in
      }
    }
  }

  Future<void> _updateTotals() async {
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

    // Get the current date components (year, month, day)
    final now = DateTime.now();
    final String year = DateFormat('yyyy').format(now);
    final String month = DateFormat('MM').format(now);
    final String day = DateFormat('dd').format(now);

    // Fetch the employee document to get the shopId
    final employeeDoc =
        await _firestore.collection('employees').doc(userId).get();

    if (employeeDoc.exists && employeeDoc.data() != null) {
      final data = employeeDoc.data() as Map<String, dynamic>;
      final shopId = data['shopId']; // Fetching shopId

      // Update the totals for this user in the Firestore path 'users/{userId}/dailyTransactions/{year}/{month}/{day}'
      await _firestore
          .collection('users')
          .doc(shopId)
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

      // You can also update totals according to shopId if needed
    } else {
      // Handle case where employee document doesn't exist
      debugPrint('Employee document does not exist or is null');
    }
  }

  Future<void> _updateTotalCash(double amount, {required bool add}) async {
    User? user =
        FirebaseAuth.instance.currentUser; // Get the authenticated user
    if (user == null) {
      return; // If the user is not authenticated, exit the function
    }

    String userId = user.uid; // Get the user's ID

    // Fetch the current cash value for this user from 'users/{userId}/weight' document
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init')
        .get();

    if (snapshot.exists) {
      double currentTotalCash = double.parse(snapshot['total_cash'] ?? '0.0');
      double newTotalCash =
          add ? currentTotalCash + amount : currentTotalCash - amount;

      // Update the 'total_cash' for this user in Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('weight')
          .doc('init')
          .update({
        'total_cash': newTotalCash.toString(),
      });

      // Fetch the shopId from the employees collection
      DocumentSnapshot employeeDoc =
          await _firestore.collection('employees').doc(userId).get();

      if (employeeDoc.exists && employeeDoc.data() != null) {
        final data = employeeDoc.data() as Map<String, dynamic>;
        final shopId = data['shopId']; // Get the shopId

        // Update the cash for the shop in the users collection
        await _firestore
            .collection('users')
            .doc(
                shopId) // Use the shopId here to access the specific shop's user document
            .collection('weight')
            .doc('init') // Assuming a similar document structure for the shop
            .update({
          'total_cash': FieldValue.increment(
              add ? amount : -amount), // Increment or decrement cash
        });
      } else {
        // Handle case where employee document doesn't exist or is null
        debugPrint('Employee document does not exist or is null');
      }
    }
  }
}
