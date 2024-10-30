import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/columns_daftar_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sellorbuy_items.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/textfieldanddfater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuyingWidget extends StatelessWidget {
  final Function(Daftarcheckmodel) onItemAdded;
  final List<Daftarcheckmodel> items;

  const BuyingWidget(
      {required this.onItemAdded, required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < 600; // Adjust threshold as needed

    // Determine aspect ratio based on device type
    final double aspectRatio = isMobile ? (18 /15) : (16 / 5);

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
                  // SVG Image inside the black container at the bottom-right corner
                  Positioned(
                    top: MediaQuery.sizeOf(context).height * .23,
                    left: MediaQuery.sizeOf(context).width * .6,
                    child: SvgPicture.asset(
                      'assets/images/undraw_credit_card_re_blml 1.svg',
                      width: MediaQuery.sizeOf(context).width * .5,
                      height: MediaQuery.sizeOf(context).width *
                          .25, // Adjust the size based on your needs
                    ),
                  ),
                  // CustomScrollView with slivers
                  CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 5),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 15),
                      ),
                      SliverToBoxAdapter(
                        child: ModalRoute.of(context)?.settings.name == '/DaftarView' || ModalRoute.of(context)?.settings.name == '/employeeDaftar' ? Textfieldanddfater(
                          onItemAdded: (Daftarcheckmodel newItem) {
                            // Add the new item
                            onItemAdded(newItem);
                          },
                        ):Container()
                      ),
                   
                      const SliverToBoxAdapter(
                        child:
                            Divider(color: Color.fromARGB(255, 114, 110, 110)),
                      ),
                      const SliverToBoxAdapter(
                        child: Sellorbuyitems(),
                      ),
                      // Change this part to directly use ColumnDaftarlist as a sliver
                      ColumnDaftarlist(
                        isBuyingItems: true,
                        items: items, 
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
