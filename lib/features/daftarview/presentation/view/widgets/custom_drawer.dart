import 'package:aldafttar/features/daftarview/presentation/view/widgets/bottom_drawer_items.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Customdrawer extends StatelessWidget {
  const Customdrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff151312),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'برنامج الدفتر',
                style: Appstyles.bold50(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Draweritemlist(
              key: drawerKey,
            ),
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
