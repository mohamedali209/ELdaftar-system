import 'package:aldafttar/features/daftarview/presentation/view/widgets/bottom_drawer_items.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Customdrawer extends StatelessWidget {
  final GlobalKey<DraweritemlistState> drawerKey;

  const Customdrawer({super.key, required this.drawerKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * .7,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF735600), // Hex color #735600 at the top
            Colors.amber, // Amber color at the bottom
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'برنامج الدفتر',
                style: Appstyles.bold50(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Draweritemlist(key: drawerKey),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Bottomdraweritems(),
          ),
        ],
      ),
    );
  }
}
