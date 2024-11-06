import 'dart:async';

import 'package:aldafttar/features/daftarview/presentation/view/manager/summarylist/cubit/summary_item_state.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';
import 'package:aldafttar/utils/commas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SummaryDftarCubit extends Cubit<SummaryDftarState> {
  SummaryDftarCubit() : super(SummaryDftarInitial());

  StreamSubscription<DocumentSnapshot>? _weightSubscription;
  StreamSubscription<DocumentSnapshot>? _dailyTransactionsSubscription;

  // Fetch data from Firestore and listen to real-time changes based on user authentication
 void fetchData() {
  emit(SummaryDftarLoading());

  // Get the current user ID from Firebase Authentication
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    // Handle case where the user is not authenticated
    emit(SummaryDftarError('No authenticated user found.'));
    return;
  }

  try {
    // Get the current date
    DateTime now = DateTime.now();
    String year = DateFormat('yyyy').format(now); // Current year (e.g., '2024')
    String month = DateFormat('MM').format(now); // Current month (e.g., '10')
    String day = DateFormat('dd').format(now); // Current day (e.g., '15')

    // Listen to 'weight' document changes under the authenticated user's document
    _weightSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('weight')
        .doc('init') // Assuming 'init' is the document for weight
        .snapshots()
        .listen((weightSnapshot) {
      if (!weightSnapshot.exists) {
        if (!isClosed) {
          emit(SummaryDftarError('Weight document does not exist.'));
        }
        return;
      }

      // Listen to 'dailyTransactions' document changes for the current year, month, and day
      _dailyTransactionsSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dailyTransactions')
          .doc(year) // Year document
          .collection(month) // Month collection
          .doc(day) // Day document
          .snapshots()
          .listen((dailyTransactionsSnapshot) {
        if (!dailyTransactionsSnapshot.exists) {
          if (!isClosed) {
            emit(SummaryDftarError('لا يوجد تعاملات اليوم'));
          }
          return;
        }

        final weightData = weightSnapshot.data() ?? {};
        final dailyTransactionsData = dailyTransactionsSnapshot.data() ?? {};

        // Safely fetch and format values
        final totalSalePrice = NumberFormatter.format(
          int.tryParse(dailyTransactionsData['totalSalePrice']?.toString() ?? '0') ?? 0,
        );

        final totalBuyingPrice = NumberFormatter.format(
          int.tryParse(dailyTransactionsData['totalBuyingPrice']?.toString() ?? '0') ?? 0,
        );

        final total18kasr = dailyTransactionsData['total18kasr']?.toString() ?? '0';
        final total21kasr = dailyTransactionsData['total21kasr']?.toString() ?? '0';
        final totalCash = NumberFormatter.formatDoubleString(weightData['total_cash'] ?? 0);

        // Create list of items for display
        final items = [
          DaftarheaderModel(title: 'مبيعات اليوم', subtitle: totalSalePrice),
          DaftarheaderModel(title: 'شراء اليوم', subtitle: totalBuyingPrice),
          DaftarheaderModel(title: 'النقدية المتاحة', subtitle: totalCash),
          DaftarheaderModel(title: '18 الكسر', subtitle: total18kasr),
          DaftarheaderModel(title: '21 الكسر', subtitle: total21kasr),
        ];

        if (!isClosed) {
          emit(SummaryDftarLoaded(items));
        }
      }, onError: (error) {
        if (!isClosed) {
          emit(SummaryDftarError('Error fetching daily transactions: ${error.toString()}'));
        }
      });
    }, onError: (error) {
      if (!isClosed) {
        emit(SummaryDftarError('Error fetching weight data: ${error.toString()}'));
      }
    });
  } catch (e) {
    if (!isClosed) {
      emit(SummaryDftarError('Error fetching data: ${e.toString()}'));
    }
  }
}
  @override
  Future<void> close() {
    _weightSubscription?.cancel();
    _dailyTransactionsSubscription?.cancel();
    return super.close();
  }
}
