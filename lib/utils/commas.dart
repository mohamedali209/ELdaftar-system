import 'package:intl/intl.dart';

class NumberFormatter {
  // Formats an integer value with commas
  static String format(int value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  // Formats a double value with commas
  static String formatDouble(double value) {
    final formatter = NumberFormat('#,###.##'); // Adjust for decimal places if needed
    return formatter.format(value);
  }
  static String formatDoubleString(String? value) {
    if (value == null || value.isEmpty) {
      return format(0); // Handle null or empty string
    }
    // Convert to double, then to int, and format
    return format((double.tryParse(value) ?? 0.0).toInt());
  }
}
