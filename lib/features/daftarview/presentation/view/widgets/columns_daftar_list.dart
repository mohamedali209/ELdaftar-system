import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/row_daftar_buying.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/row_ofdaftar.dart';
import 'package:flutter/material.dart';

class ColumnDaftarlist extends StatelessWidget {
  final List<Daftarcheckmodel> items;
  final bool isBuyingItems; // New parameter to differentiate between selling and buying items

  const ColumnDaftarlist(
      {required this.items, required this.isBuyingItems, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return isBuyingItems
              ? RowofdaftarBuyingItem(
                  daftarcheckmodel: items[index]) // Use the buying widget
              : Rowofdaftar(daftarcheckmodel: items[index]);
        },
        childCount: items.length, // Set the number of items
      ),
    );
  }
}
