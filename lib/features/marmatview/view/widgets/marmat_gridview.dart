import 'package:aldafttar/features/marmatview/model/marmat_model.dart';
import 'package:aldafttar/features/marmatview/view/widgets/marmat_item.dart';
import 'package:flutter/material.dart';

class Marmatgridview extends StatelessWidget {
  const Marmatgridview({super.key, required this.items});
  final List<MarmatModel> items;

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
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, // Responsive column count
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) =>  MarmatItem(marmatModel: items[index],),
    );
  }
}

