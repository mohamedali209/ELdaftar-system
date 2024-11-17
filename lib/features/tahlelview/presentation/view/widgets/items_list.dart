import 'package:flutter/material.dart';

class ItemsList extends StatelessWidget {
  final List<String> items;
  final List<Color> colors;

  const ItemsList({super.key, required this.items, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  items[index],
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
