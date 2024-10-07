import 'package:aldafttar/features/Hesabatview/presentation/view/models/hesab_item_model.dart';
import 'package:aldafttar/features/Hesabatview/presentation/view/widgets/hesab_item.dart';
import 'package:flutter/material.dart';

class Hesabatgridview extends StatelessWidget {
  const Hesabatgridview({super.key, required this.items});

  final List<Hesabmodel> items;

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine crossAxisCount based on screen width (responsive layout)
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 1; // Mobile screen
    } else if (screenWidth < 1300) {
      crossAxisCount = 2; // Tablet screen
    } else {
      crossAxisCount = 4; // Large screen (desktop)
    }

    return GridView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // Responsive column count
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) => Hesabitem(
        hesabmodel: items[index],
      ),
    );
  }
}
