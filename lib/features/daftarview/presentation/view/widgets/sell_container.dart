import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/columns_daftar_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sellorbuy_items.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/textfieldanddfater.dart';
import 'package:flutter/material.dart';

class SellingWidget extends StatelessWidget {
  final Function(Daftarcheckmodel) onItemAdded;
  final List<Daftarcheckmodel> items;

  const SellingWidget({
    required this.onItemAdded,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < 600; // Adjust threshold as needed

    final double aspectRatio = isMobile ? (18 / 15) : (16 / 5);

    return Padding(
      padding: isMobile
          ? EdgeInsets.zero // No padding for mobile
          : const EdgeInsets.symmetric(
              horizontal: 30, vertical: 15), // Padding for larger screens
      child: Custombackgroundcontainer(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          child: AspectRatio(
            aspectRatio: aspectRatio, // Use the determined aspect ratio
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.sizeOf(context).height * .23,
                    left: MediaQuery.sizeOf(context).width * .4,
                    child: Image.asset(
                      'assets/images/test.png',
                      width: MediaQuery.sizeOf(context).width * .5,
                      height: MediaQuery.sizeOf(context).width * .25,
                    ),
                  ),
                  CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 15),
                      ),
                      SliverToBoxAdapter(
                        child: Textfieldanddfater(
                          onItemAdded: (Daftarcheckmodel newItem) {
                            // Add the new item
                            onItemAdded(newItem);
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child:
                            Divider(color: Color.fromARGB(255, 114, 110, 110)),
                      ),
                      const SliverToBoxAdapter(
                        child: Sellorbuyitems(),
                      ),
                      ColumnDaftarlist(
                        isBuyingItems: false,
                        items: items,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
