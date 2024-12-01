import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/collection_row.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/row_buying_collection.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:flutter/material.dart';

class CollectionColumnDaftarlist extends StatelessWidget {
  final List<Daftarcheckmodel> items;
  final bool
      isBuyingItems; // New parameter to differentiate between selling and buying items

  const CollectionColumnDaftarlist(
      {required this.items, required this.isBuyingItems, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return isBuyingItems
              ? CollectionRowofdaftarBuyingItem(
                  daftarcheckmodel: items[index]) // Use the buying widget
              : CollectionRowofdaftar(daftarcheckmodel: items[index]);
        },
        childCount: items.length, // Set the number of items
      ),
    );
  }
}
