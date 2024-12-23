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
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 700));

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

      final salesAmount = double.tryParse(newItemWithNum.price) ?? 0;
      await updateSalesSummary(salesAmount);
      final itemWeight = double.tryParse(newItemWithNum.gram) ?? 0.0;
      final itemType =
          newItemWithNum.details; // Assuming 'type' holds the item type
      await updateSalesSummaryPercentage(itemType, itemWeight);
    } catch (e) {
      debugPrint('Error adding selling item: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void addBuyingItem(Daftarcheckmodel newItem) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 700));
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
      final purchaseAmount = double.tryParse(newItemWithNum.price) ?? 0;
      await updatePurchaseSummary(purchaseAmount);
    } catch (e) {
      debugPrint('Error adding buying item: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateSalesSummary(double salesAmount) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      DocumentSnapshot employeeDoc =
          await _firestore.collection('employees').doc(userId).get();

      final data = employeeDoc.data() as Map<String, dynamic>?;
      final shopId = data?['shopId'];
      final insightsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(shopId)
          .collection('insights')
          .doc('insights_document_id');

      final docSnapshot = await insightsRef.get();
      DateTime now = DateTime.now();

      // Initialize sales_summary if it doesn't exist
      if (!docSnapshot.exists ||
          docSnapshot.data() == null ||
          !docSnapshot.data()!.containsKey('sales_summary')) {
        await insightsRef.set({
          'sales_summary': {'weekly': [], 'monthly': [], 'yearly': []}
        }, SetOptions(merge: true));
      }

      // Retrieve or initialize weekly, monthly, and yearly data arrays
      List<dynamic> weeklyData =
          (docSnapshot.data()?['sales_summary']?['weekly'] as List<dynamic>?) ??
              [];
      List<dynamic> monthlyData = (docSnapshot.data()?['sales_summary']
              ?['monthly'] as List<dynamic>?) ??
          [];
      List<dynamic> yearlyData =
          (docSnapshot.data()?['sales_summary']?['yearly'] as List<dynamic>?) ??
              [];

      // Update each period with the sales amount
      weeklyData = _updateWeeklySummary(weeklyData, now, salesAmount);
      monthlyData = _updateMonthlySummary(monthlyData, now, salesAmount);
      yearlyData = _updateYearlySummary(yearlyData, now, salesAmount);

      // Save all periods back to Firestore in one update call
      await insightsRef.update({
        'sales_summary.weekly': weeklyData,
        'sales_summary.monthly': monthlyData,
        'sales_summary.yearly': yearlyData,
      });
    }
  }

  Future<void> updateSalesSummaryPercentage(
      String itemType, double itemWeight) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      DocumentSnapshot employeeDoc =
          await _firestore.collection('employees').doc(userId).get();

      final data = employeeDoc.data() as Map<String, dynamic>?;
      final shopId = data?['shopId'];
      final insightsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(shopId)
          .collection('insights')
          .doc('insights_document_id');

      final docSnapshot = await insightsRef.get();

      // Define the default structure for initial items
      final Map<String, Map<String, dynamic>> initialItems = {
        'خاتم': {'weight': 0.0, 'percentage': "0.00"},
        'دبلة': {'weight': 0.0, 'percentage': "0.00"},
        'سلسلة': {'weight': 0.0, 'percentage': "0.00"},
        'توينز': {'weight': 0.0, 'percentage': "0.00"},
        'حلق': {'weight': 0.0, 'percentage': "0.00"},
        'محبس': {'weight': 0.0, 'percentage': "0.00"},
        'انسيال': {'weight': 0.0, 'percentage': "0.00"},
        'اسورة': {'weight': 0.0, 'percentage': "0.00"},
        'تعليقة': {'weight': 0.0, 'percentage': "0.00"},
        'كوليه': {'weight': 0.0, 'percentage': "0.00"},
        'غوايش': {'weight': 0.0, 'percentage': "0.00"},
        'سبائك': {'weight': 0.0, 'percentage': "0.00"},
        'جنيهات': {'weight': 0.0, 'percentage': "0.00"},
        'كسر': {'weight': 0.0, 'percentage': "0.00"},
      };

      // Get the current date
      final DateTime now = DateTime.now();

      // Retrieve or initialize last updated dates
      DateTime lastWeeklyUpdate =
          (docSnapshot.data()?['lastWeeklyUpdate'] as Timestamp?)?.toDate() ??
              now;
      DateTime lastMonthlyUpdate =
          (docSnapshot.data()?['lastMonthlyUpdate'] as Timestamp?)?.toDate() ??
              now;
      DateTime lastYearlyUpdate =
          (docSnapshot.data()?['lastYearlyUpdate'] as Timestamp?)?.toDate() ??
              now;

      // Check if we need to reset the weekly data (every Monday)
      if (now.weekday == DateTime.monday &&
          now.difference(lastWeeklyUpdate).inDays >= 7) {
        await insightsRef.update({
          'sales_percentage.weekly': initialItems,
          'sales_percentage.totalWeeklyGrams': 0.0,
          'lastWeeklyUpdate': now,
        });
      }

      // Check if we need to reset the monthly data (every 4 weeks)
      if (now.difference(lastMonthlyUpdate).inDays >= 28) {
        await insightsRef.update({
          'sales_percentage.monthly': initialItems,
          'sales_percentage.totalMonthlyGrams': 0.0,
          'lastMonthlyUpdate': now,
        });
      }

      // Check if we need to reset the yearly data (every January 1st)
      if (now.month == 1 && lastYearlyUpdate.year < now.year) {
        await insightsRef.update({
          'sales_percentage.yearly': initialItems,
          'sales_percentage.totalYearlyGrams': 0.0,
          'lastYearlyUpdate': now,
        });
      }

      // Fetch updated data with null checks
      final updatedDocSnapshot = await insightsRef.get();
      Map<String, dynamic> weeklyData = Map<String, dynamic>.from(
          updatedDocSnapshot.data()?['sales_percentage']?['weekly'] ??
              initialItems);
      Map<String, dynamic> monthlyData = Map<String, dynamic>.from(
          updatedDocSnapshot.data()?['sales_percentage']?['monthly'] ??
              initialItems);
      Map<String, dynamic> yearlyData = Map<String, dynamic>.from(
          updatedDocSnapshot.data()?['sales_percentage']?['yearly'] ??
              initialItems);

      // Update weights
      double totalWeeklyGrams = (updatedDocSnapshot.data()?['sales_percentage']
                  ?['totalWeeklyGrams'] as num?)
              ?.toDouble() ??
          0.0;
      double totalMonthlyGrams = (updatedDocSnapshot.data()?['sales_percentage']
                  ?['totalMonthlyGrams'] as num?)
              ?.toDouble() ??
          0.0;
      double totalYearlyGrams = (updatedDocSnapshot.data()?['sales_percentage']
                  ?['totalYearlyGrams'] as num?)
              ?.toDouble() ??
          0.0;

      double currentWeeklyWeight =
          (weeklyData[itemType]?['weight'] ?? 0.0) as double;
      double currentMonthlyWeight =
          (monthlyData[itemType]?['weight'] ?? 0.0) as double;
      double currentYearlyWeight =
          (yearlyData[itemType]?['weight'] ?? 0.0) as double;

      weeklyData[itemType]['weight'] = currentWeeklyWeight + itemWeight;
      monthlyData[itemType]['weight'] = currentMonthlyWeight + itemWeight;
      yearlyData[itemType]['weight'] = currentYearlyWeight + itemWeight;

      totalWeeklyGrams += itemWeight;
      totalMonthlyGrams += itemWeight;
      totalYearlyGrams += itemWeight;

      // Calculate percentage for each item type
      final weeklyPercentageData =
          _calculatePercentageForItems(weeklyData, totalWeeklyGrams);
      final monthlyPercentageData =
          _calculatePercentageForItems(monthlyData, totalMonthlyGrams);
      final yearlyPercentageData =
          _calculatePercentageForItems(yearlyData, totalYearlyGrams);

      // Save all data back to Firestore
      await insightsRef.update({
        'sales_percentage.weekly': weeklyPercentageData,
        'sales_percentage.monthly': monthlyPercentageData,
        'sales_percentage.yearly': yearlyPercentageData,
        'sales_percentage.totalWeeklyGrams': totalWeeklyGrams,
        'sales_percentage.totalMonthlyGrams': totalMonthlyGrams,
        'sales_percentage.totalYearlyGrams': totalYearlyGrams,
      });
    }
  }

// Helper function to calculate percentage
  Map<String, dynamic> _calculatePercentageForItems(
      Map<String, dynamic> itemWeights, double totalGrams) {
    Map<String, dynamic> percentages = {};
    itemWeights.forEach((item, weightMap) {
      double weight = (weightMap['weight'] ?? 0.0) as double;
      double percentage = (totalGrams > 0) ? (weight / totalGrams) * 100 : 0.0;
      percentages[item] = {
        'weight': weight,
        'percentage': percentage.toStringAsFixed(2),
      };
    });
    return percentages;
  }

// Helper function to calculate the percentage for each item type based on the total grams sold

// Helper functions to manage the summaries
  List<dynamic> _updateWeeklySummary(
      List<dynamic> weeklyData, DateTime now, double salesAmount) {
    // Calculate the day index for the current day in the weekly format (0 for Monday to 6 for Sunday)
    int dayOfWeek = (now.weekday - 1) % 7; // Monday is 0, Sunday is 6
    String period = 'day-$dayOfWeek';

    // Remove entries older than 7 days
    weeklyData.removeWhere(
        (entry) => now.difference(DateTime.parse(entry['date'])).inDays >= 7);

    // Check if there's already an entry for the current dayOfWeek
    int existingIndex =
        weeklyData.indexWhere((entry) => entry['period'] == period);

    // If entry exists, update the sales amount for the current day
    if (existingIndex >= 0) {
      weeklyData[existingIndex]['sales'] += salesAmount;
    } else {
      // If no entry exists for today, add a new one
      weeklyData.add({
        'period': period,
        'sales': salesAmount,
        'date': now.toIso8601String()
      });
    }

    return weeklyData;
  }

  List<dynamic> _updateMonthlySummary(
      List<dynamic> monthlyData, DateTime now, double salesAmount) {
    int weekOfMonth =
        ((now.day - 1) ~/ 7) + 1; // Calculate which week of the month it is
    String period = '${now.month}-$weekOfMonth';

    // Remove entries older than 4 weeks (1 month)
    monthlyData
        .removeWhere((entry) => _isOlderThanOneMonth(entry['date'], now));
    // Update or add sales for the current week
    int existingIndex =
        monthlyData.indexWhere((entry) => entry['period'] == period);
    if (existingIndex >= 0) {
      monthlyData[existingIndex]['sales'] += salesAmount;
    } else {
      monthlyData.add({
        'period': period,
        'sales': salesAmount,
        'date': now.toIso8601String()
      });
    }
    return monthlyData;
  }

  List<dynamic> _updateYearlySummary(
      List<dynamic> yearlyData, DateTime now, double salesAmount) {
    String monthYear = '${now.month}-${now.year}';

    // Remove entries older than 12 months
    yearlyData.removeWhere((entry) => _isOlderThanOneYear(entry['date'], now));
    // Update or add sales for the current month
    int existingIndex =
        yearlyData.indexWhere((entry) => entry['month'] == monthYear);
    if (existingIndex >= 0) {
      yearlyData[existingIndex]['sales'] += salesAmount;
    } else {
      yearlyData.add({
        'month': monthYear,
        'sales': salesAmount,
        'date': now.toIso8601String()
      });
    }
    return yearlyData;
  }

// Helper methods for period checking
  bool _isOlderThanOneMonth(String date, DateTime now) {
    DateTime dateParsed = DateTime.parse(date);
    return now.difference(dateParsed).inDays >= 30;
  }

  bool _isOlderThanOneYear(String date, DateTime now) {
    DateTime dateParsed = DateTime.parse(date);
    return now.difference(dateParsed).inDays >= 365;
  }

  Future<void> updatePurchaseSummary(double purchaseAmount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      DocumentSnapshot employeeDoc =
          await _firestore.collection('employees').doc(userId).get();

      final data = employeeDoc.data() as Map<String, dynamic>?;
      final shopId = data?['shopId'];
      final insightsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(shopId)
          .collection('insights')
          .doc('insights_document_id');

      final docSnapshot = await insightsRef.get();
      DateTime now = DateTime.now();

      // Check if the document and purchase_summary field exist, initialize if necessary
      if (!docSnapshot.exists ||
          docSnapshot.data() == null ||
          !docSnapshot.data()!.containsKey('purchase_summary')) {
        await insightsRef.set({
          'purchase_summary': {'weekly': [], 'monthly': [], 'yearly': []}
        }, SetOptions(merge: true));
      }

      // Retrieve or initialize `weekly`, `monthly`, `yearly` data arrays
      List<dynamic> weeklyData = (docSnapshot.data()?['purchase_summary']
              ?['weekly'] as List<dynamic>?) ??
          [];
      List<dynamic> monthlyData = (docSnapshot.data()?['purchase_summary']
              ?['monthly'] as List<dynamic>?) ??
          [];
      List<dynamic> yearlyData = (docSnapshot.data()?['purchase_summary']
              ?['yearly'] as List<dynamic>?) ??
          [];

      // Update each period with the purchase amount
      weeklyData =
          _updateWeeklySummarypurchase(weeklyData, now, purchaseAmount);
      monthlyData =
          _updateMonthlySummarypurchase(monthlyData, now, purchaseAmount);
      yearlyData =
          _updateYearlySummarypurchase(yearlyData, now, purchaseAmount);

      // Save all periods back to Firestore in one update call
      await insightsRef.update({
        'purchase_summary.weekly': weeklyData,
        'purchase_summary.monthly': monthlyData,
        'purchase_summary.yearly': yearlyData,
      });
    }
  }

// Helper functions to manage the purchase summaries for each period
  List<dynamic> _updateWeeklySummarypurchase(
      List<dynamic> weeklyData, DateTime now, double purchaseAmount) {
    // Calculate the day index for the current day in the weekly format (0 for Monday to 6 for Sunday)
    int dayOfWeek = (now.weekday - 1) % 7; // Monday is 0, Sunday is 6
    String period = 'day-$dayOfWeek';

    // Remove entries older than 7 days
    weeklyData.removeWhere(
        (entry) => now.difference(DateTime.parse(entry['date'])).inDays >= 7);

    // Check if there's already an entry for today's dayOfWeek
    int existingIndex =
        weeklyData.indexWhere((entry) => entry['period'] == period);

    // If entry exists, update the purchase amount for the current day
    if (existingIndex >= 0) {
      weeklyData[existingIndex]['purchase'] += purchaseAmount;
    } else {
      // If no entry exists for today, add a new one
      weeklyData.add({
        'period': period,
        'purchase': purchaseAmount,
        'date': now.toIso8601String()
      });
    }

    return weeklyData;
  }

  List<dynamic> _updateMonthlySummarypurchase(
      List<dynamic> monthlyData, DateTime now, double purchaseAmount) {
    int weekOfMonth =
        ((now.day - 1) ~/ 7) + 1; // Calculate which week of the month it is
    String period = '${now.month}-$weekOfMonth';

    // Remove entries older than 4 weeks (1 month)
    monthlyData
        .removeWhere((entry) => _isOlderThanOneMonth(entry['date'], now));
    // Update or add purchase for the current week
    int existingIndex =
        monthlyData.indexWhere((entry) => entry['period'] == period);
    if (existingIndex >= 0) {
      monthlyData[existingIndex]['purchase'] += purchaseAmount;
    } else {
      monthlyData.add({
        'period': period,
        'purchase': purchaseAmount,
        'date': now.toIso8601String()
      });
    }
    return monthlyData;
  }

  List<dynamic> _updateYearlySummarypurchase(
      List<dynamic> yearlyData, DateTime now, double purchaseAmount) {
    String monthYear = '${now.month}-${now.year}';

    // Remove entries older than 12 months
    yearlyData.removeWhere((entry) => _isOlderThanOneYear(entry['date'], now));
    // Update or add purchase for the current month
    int existingIndex =
        yearlyData.indexWhere((entry) => entry['month'] == monthYear);
    if (existingIndex >= 0) {
      yearlyData[existingIndex]['purchase'] += purchaseAmount;
    } else {
      yearlyData.add({
        'month': monthYear,
        'purchase': purchaseAmount,
        'date': now.toIso8601String()
      });
    }
    return yearlyData;
  }

  Future<void> _addItemGramsToWeight(Daftarcheckmodel newItem) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;

      // Fetch the shopId from the employees collection
      DocumentSnapshot employeeSnapshot =
          await _firestore.collection('employees').doc(userId).get();

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
            } else if (item.details.contains('توينز')) {
              itemType = 'توينز';
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
     DocumentSnapshot employeeDoc =
          await _firestore.collection('employees').doc(userId).get();
            final data = employeeDoc.data() as Map<String, dynamic>;
        final shopId = data['shopId']; // Get the shopId

    // Fetch the current cash value for this user from 'users/{userId}/weight' document
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(shopId)
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
          .doc(shopId)
          .collection('weight')
          .doc('init')
          .update({
        'total_cash': newTotalCash.toString(),
      });

    
    }
  }

  void modifyItem(Daftarcheckmodel modifiedItem,
      {bool isBuyingItem = false}) async {
    emit(state.copyWith(isLoading: true));
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
          price: '0'),
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
          price: '0'),
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

      emit(EmployeesitemState(
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

      emit(EmployeesitemState(
        sellingItems: state.sellingItems, // Do not modify selling items
        buyingItems: updatedBuyingItems,
      ));
    }

    // Update Firestore and totals
    await _updateFirestore();
    await _updateTotals();

    emit(state.copyWith(isLoading: false));
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

  Future<void> updateInventory(
      Daftarcheckmodel item, int adadDifference, double gramDifference,
      {bool isAyarChange = false}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    String userId = user.uid;
    DocumentSnapshot employeeDoc =
        await _firestore.collection('employees').doc(userId).get();
    final data = employeeDoc.data() as Map<String, dynamic>?;
    final shopId = data?['shopId'];
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(shopId)
        .collection('weight')
        .doc('init')
        .get();

    if (snapshot.exists) {
      String itemType =
          _getItemType(item.details); // Helper function to get item type
      bool is18k = item.ayar.contains('18k');
      bool is24k = item.ayar.contains('24k'); // For سبائك (Sabaek)

      if (itemType.isNotEmpty) {
        if (itemType == 'سبائك' && is24k) {
          int currentSabaekCount = int.parse(snapshot['sabaek_count'] ?? '0');
          double currentSabaekWeight =
              double.parse(snapshot['sabaek_weight'] ?? '0.0');

          int newSabaekCount = currentSabaekCount + adadDifference;
          double newSabaekWeight = currentSabaekWeight + gramDifference;

          await _firestore
              .collection('users')
              .doc(shopId)
              .collection('weight')
              .doc('init')
              .update({
            'sabaek_count': newSabaekCount.toString(),
            'sabaek_weight': newSabaekWeight.toString(),
          });
        } else if (itemType == 'جنيهات') {
          int currentGnihatCount = int.parse(snapshot['gnihat_count'] ?? '0');
          double currentGnihatWeight =
              double.parse(snapshot['gnihat_weight'] ?? '0.0');

          int newGnihatCount = currentGnihatCount + adadDifference;
          double newGnihatWeight = currentGnihatWeight + gramDifference;

          await _firestore
              .collection('users')
              .doc(shopId)
              .collection('weight')
              .doc('init')
              .update({
            'gnihat_count': newGnihatCount.toString(),
            'gnihat_weight': newGnihatWeight.toString(),
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
              .doc(shopId)
              .collection('weight')
              .doc('init')
              .update({
            quantityField: newQuantity.toString(),
            weightField: newWeight.toString(),
          });

          if (is18k) {
            double total18kWeight =
                double.parse(snapshot['total18kWeight'] ?? '0.0');
            total18kWeight += gramDifference;
            await _firestore
                .collection('users')
                .doc(shopId)
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
                .doc(shopId)
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
    if (details.contains('توينز')) return 'توينز';
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
        oldBuyingItem.price != modifiedItem.price||oldBuyingItem.gram!=modifiedItem.gram) {
      await _subtractItemGramsFromWeight(oldBuyingItem);
      await _addNewItemGramsToNewAyar(modifiedItem);
    } else {
      // int adadDifference =
      //     int.parse(oldBuyingItem.adad) - int.parse(modifiedItem.adad);
      // double gramDifference =
      //     double.parse(oldBuyingItem.gram) - double.parse(modifiedItem.gram);

      // if (adadDifference != 0 || gramDifference != 0) {
      //   await updateInventory(modifiedItem, adadDifference, gramDifference);
      // }
    }
  }

  Future<void> updateTotalCash(double priceDifference) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    String userId = user.uid;
    DocumentSnapshot employeeDoc =
        await _firestore.collection('employees').doc(userId).get();
    final data = employeeDoc.data() as Map<String, dynamic>?;
    final shopId = data?['shopId'];
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(shopId)
        .collection('weight')
        .doc('init')
        .get();

    if (snapshot.exists) {
      double totalCash = double.parse(snapshot['total_cash'] ?? '0.0');
      totalCash += priceDifference;

      await _firestore
          .collection('users')
          .doc(shopId)
          .collection('weight')
          .doc('init')
          .update({
        'total_cash': totalCash.toString(),
      });
    }
  }

  Future<void> _subtractItemGramsFromWeight(Daftarcheckmodel oldItem) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure the user is authenticated

    String userId = user.uid;
    DocumentSnapshot employeeDoc =
        await _firestore.collection('employees').doc(userId).get();
    final data = employeeDoc.data() as Map<String, dynamic>?;
    final shopId = data?['shopId'];
    DocumentSnapshot weightSnapshot = await _firestore
        .collection('users')
        .doc(shopId)
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
          .doc(shopId)
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
    DocumentSnapshot employeeDoc =
        await _firestore.collection('employees').doc(userId).get();
    final data = employeeDoc.data() as Map<String, dynamic>?;
    final shopId = data?['shopId'];
    DocumentSnapshot weightSnapshot = await _firestore
        .collection('users')
        .doc(shopId)
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
          .doc(shopId)
          .collection('weight')
          .doc('init')
          .update({
        'total18kKasr': currentTotal18kKasr.toString(),
        'total21kKasr': currentTotal21kKasr.toString(),
      });
    }
  }

  void deleteItem(Daftarcheckmodel itemToDelete) async {
  emit(state.copyWith(isLoading: true));

  // Create updated lists for selling and buying items
  List<Daftarcheckmodel> updatedSellingItems = List.from(state.sellingItems);
  List<Daftarcheckmodel> updatedBuyingItems = List.from(state.buyingItems);

  if (state.sellingItems.contains(itemToDelete)) {
    // Remove the item from selling items
    updatedSellingItems = updatedSellingItems
        .where((item) => item.num != itemToDelete.num)
        .toList();

    // Update total cash and inventory for selling items
    await _updateCash(itemToDelete, isSellingItem: true);
    await updateInventory(
      itemToDelete,
      int.parse(itemToDelete.adad),
      double.parse(itemToDelete.gram),
    );
  } else if (state.buyingItems.contains(itemToDelete)) {
    // Remove the item from buying items
    updatedBuyingItems = updatedBuyingItems
        .where((item) => item.num != itemToDelete.num)
        .toList();

    // Update total cash for buying items
    await _updateCash(itemToDelete, isSellingItem: false);

    // Check if the item type is "سبائك" and subtract from inventory
    if (itemToDelete.details.contains('سبائك')) {
      await updateInventory(
        itemToDelete,
        -int.parse(itemToDelete.adad),
        -double.parse(itemToDelete.gram),
      );
    } else {
      // Handle other buying items
      await _subtractItemGramsFromWeight(itemToDelete);
    }
  }

  // Emit updated state with modified lists
  emit(EmployeesitemState(
    sellingItems: updatedSellingItems,
    buyingItems: updatedBuyingItems,
  ));

  // Perform additional updates to Firestore and totals
  await _updateFirestore();
  await _updateTotals();

  emit(state.copyWith(isLoading: false));
}


  Future<void> _updateCash(Daftarcheckmodel item,
      {required bool isSellingItem}) async {
    // Get the current user ID from Firebase Authentication
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot employeeDoc =
        await _firestore.collection('employees').doc(userId).get();
    final data = employeeDoc.data() as Map<String, dynamic>?;
    final shopId = data?['shopId'];
    if (userId == null) {
      // Handle case where the user is not authenticated
      debugPrint('Error: No authenticated user found.');
      return;
    }

    // Access the 'weight' collection under the user's document
    DocumentSnapshot cashSnapshot = await _firestore
        .collection('users')
        .doc(shopId)
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
          .doc(shopId)
          .collection('weight')
          .doc('init')
          .update({
        'total_cash': totalCash.toString(),
      });
    }
  }
}
