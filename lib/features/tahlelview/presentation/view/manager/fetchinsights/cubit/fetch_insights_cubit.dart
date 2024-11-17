import 'package:aldafttar/features/tahlelview/presentation/view/manager/fetchinsights/cubit/fetch_insights_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchInsightsCubit extends Cubit<FetchInsightsState> {
  FetchInsightsCubit() : super(FetchInsightsInitial());

 Future<void> fetchInsightsSummary(String period) async {
  emit(FetchInsightsLoading());
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final insightsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('insights')
          .doc('insights_document_id');

      final docSnapshot = await insightsRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() ?? {};
        final salesSummary = data['sales_summary'] ?? {};
        final purchaseSummary = data['purchase_summary'] ?? {};

        String firestorePeriod = _mapSelectedPeriodToFirestoreKey(period);
        List<double> salesData =
            _getSalesDataForPeriod(salesSummary, firestorePeriod);
        List<double> purchaseData =
            _getPurchaseDataForPeriod(purchaseSummary, firestorePeriod);

        // Fetch sales percentage from the sales_percentage map
  // Fetch and parse sales percentage data
final salesPercentage = data['sales_percentage'] ?? {};
print("Sales percentage from Firestore: $salesPercentage"); // Log this

Map<String, double> salesPercentageData = {};

// Determine the correct period (yearly, monthly, weekly)
Map<String, dynamic> periodMap = {};
switch (period) {
  case 'سنوي':
    periodMap = salesPercentage['yearly'] ?? {};
    break;
  case 'شهري':
    periodMap = salesPercentage['monthly'] ?? {};
    break;
  case 'اسبوعي':
    periodMap = salesPercentage['weekly'] ?? {};
    break;
  default:
    print("Invalid period: $period");
    break;
}

// Extract the data for the selected period
periodMap.forEach((key, value) {
  if (value is Map && value.containsKey('percentage')) {
    double percentage = double.tryParse(value['percentage'].toString()) ?? 0.0;
    if (percentage > 0) {
      salesPercentageData[key] = percentage;
    }
  }
});

print("Parsed sales percentage data: $salesPercentageData"); // Log this

// Emit success state with all relevant data
emit(FetchInsightsSuccess(salesData, purchaseData, salesPercentageData));

      } else {
        emit(FetchInsightsFailure("No data available."));
      }
    } else {
      emit(FetchInsightsFailure("User not authenticated."));
    }
  } catch (e) {
    emit(FetchInsightsFailure("Failed to fetch insights: ${e.toString()}"));
  }
}

  String _mapSelectedPeriodToFirestoreKey(String selectedPeriod) {
    switch (selectedPeriod) {
      case 'سنوي':
        return 'yearly';
      case 'شهري':
        return 'monthly';
      case 'أسبوعي':
        return 'weekly';
      default:
        return 'weekly';
    }
  }

  List<double> _getPurchaseDataForPeriod(
      Map<String, dynamic> purchaseSummary, String period) {
    // Check if the period exists in the purchase summary
    if (!purchaseSummary.containsKey(period) ||
        purchaseSummary[period] == null) {
      // Return a filled list with default values (0.0)
      return period == 'weekly' ? List.filled(7, 0.0) : List.filled(12, 0.0);
    }

    List<dynamic> periodData = purchaseSummary[period] ?? [];
    List<double> completePurchaseData =
        List.filled(period == 'weekly' ? 7 : 12, 0.0);

    if (period == 'weekly') {
      // Process weekly data (7 days)
      for (var entry in periodData) {
        if (entry != null && entry is Map<String, dynamic>) {
          String? dayString = entry['period'];
          if (dayString != null) {
            int dayIndex = _getDayIndexFromString(dayString);
            if (dayIndex >= 0 && dayIndex < 7) {
              completePurchaseData[dayIndex] =
                  (entry['purchase'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }
    } else if (period == 'monthly') {
      // Process monthly data (4 weeks)
      completePurchaseData = List.filled(4, 0.0);
      int currentWeek = _getCurrentWeekOfMonth();
      for (var entry in periodData) {
        if (entry != null && entry is Map<String, dynamic>) {
          String? weekString =
              entry['period']; // Assuming 'week' is used for weekly data
          if (weekString != null) {
            int weekIndex = _getWeekIndexFromString(weekString);
            if (weekIndex >= 0 && weekIndex < 4 && weekIndex < currentWeek) {
              completePurchaseData[weekIndex] =
                  (entry['purchase'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }
    } else if (period == 'yearly') {
      // Process yearly data (12 months)
      for (var entry in periodData) {
        if (entry != null && entry is Map<String, dynamic>) {
          String? monthString = entry['month'];
          if (monthString != null) {
            int monthIndex = _getMonthFromString(monthString);
            if (monthIndex >= 0 && monthIndex < 12) {
              completePurchaseData[monthIndex] =
                  (entry['purchase'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }
    }

    return completePurchaseData;
  }

  List<double> _getSalesDataForPeriod(
      Map<String, dynamic> salesSummary, String period) {
    // Check if the period exists in the sales summary
    if (!salesSummary.containsKey(period) || salesSummary[period] == null) {
      // Return a filled list with default values (0.0)
      return period == 'weekly' ? List.filled(7, 0.0) : List.filled(12, 0.0);
    }

    List<dynamic> periodData = salesSummary[period] ?? [];
    List<double> completeSalesData =
        List.filled(period == 'weekly' ? 7 : 12, 0.0);

    if (period == 'weekly') {
      // Process weekly data (7 days)
      for (var entry in periodData) {
        if (entry != null && entry is Map<String, dynamic>) {
          String? dayString = entry['period'];
          if (dayString != null) {
            int dayIndex = _getDayIndexFromString(dayString);
            if (dayIndex >= 0 && dayIndex < 7) {
              completeSalesData[dayIndex] =
                  (entry['sales'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }
    } else if (period == 'monthly') {
      // Process monthly data (4 weeks)
      completeSalesData = List.filled(4, 0.0);
      int currentWeek = _getCurrentWeekOfMonth();
      for (var entry in periodData) {
        if (entry != null && entry is Map<String, dynamic>) {
          String? weekString =
              entry['period']; // Assuming 'week' is used for weekly data
          if (weekString != null) {
            int weekIndex = _getWeekIndexFromString(weekString);
            if (weekIndex >= 0 && weekIndex < 4 && weekIndex < currentWeek) {
              completeSalesData[weekIndex] =
                  (entry['sales'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }
    } else if (period == 'yearly') {
      // Process yearly data (12 months)
      for (var entry in periodData) {
        if (entry != null && entry is Map<String, dynamic>) {
          String? monthString = entry['month'];
          if (monthString != null) {
            int monthIndex = _getMonthFromString(monthString);
            if (monthIndex >= 0 && monthIndex < 12) {
              completeSalesData[monthIndex] =
                  (entry['sales'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }
    }

    return completeSalesData;
  }

  int _getDayIndexFromString(String dayString) {
    try {
      List<String> parts = dayString.split('-');
      int day = int.parse(parts[1]);
      int dayIndex = (day % 7);
      if (dayIndex == 0) dayIndex = 7; // Adjusting for Sunday
      return dayIndex;
    } catch (e) {
      return -1;
    }
  }

  int _getCurrentWeekOfMonth() {
    DateTime now = DateTime.now();
    int dayOfMonth = now.day;
    // Determine which week of the month we're in (1 to 4)
    return ((dayOfMonth - 1) ~/ 7) +
        1; // Divide by 7 and add 1 to get week number
  }

  int _getWeekIndexFromString(String weekString) {
    try {
      List<String> parts = weekString.split('-');
      return int.parse(parts[1]) - 1;
    } catch (e) {
      return -1;
    }
  }

  int _getMonthFromString(String monthString) {
    try {
      List<String> parts = monthString.split('-');
      int month = int.parse(parts[0]) - 1;
      return month;
    } catch (e) {
      return -1;
    }
  }
}
