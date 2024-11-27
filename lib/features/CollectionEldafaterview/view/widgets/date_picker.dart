import 'package:aldafttar/features/CollectionEldafaterview/manager/cubit/collectiondfater_cubit.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    // Capture the Cubit instance before the async operation
    final collectionCubit = context.read<CollectiondfaterCubit>();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Change the primary color (header background color)
            primaryColor: Colors.amber,
            // Change the container (background) color
            dialogBackgroundColor: Colors.grey[200],
            // Change the color of the confirm/cancel buttons
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            // Customize the text style (for days, years, etc.)
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      final String year = DateFormat('yyyy').format(pickedDate);
      final String month = DateFormat('MM').format(pickedDate);
      final String day = DateFormat('dd').format(pickedDate);

      // Use the captured Cubit instance
      collectionCubit.fetchTransactionsForDate(year, month, day);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            selectedDate != null
                ? 'تاريخ : ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                : 'لا يوجد تاريخ',
            style: Appstyles.daftartodayheader(context).copyWith(fontSize: 16),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              'تحديد التاريخ',
              style: Appstyles.regular25(context),
            ),
          ),
        ],
      ),
    );
  }
}
