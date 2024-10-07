import 'package:aldafttar/features/Gardview/presentation/view/widgets/elgard_expanded_container.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/gardfawry_scaffold.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/adaptive_layout.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_drawer.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/drawer_item_list.dart';
import 'package:flutter/material.dart';

final GlobalKey<DraweritemlistState> drawerKey =
    GlobalKey<DraweritemlistState>();

class Gardfawryview extends StatefulWidget {
  const Gardfawryview({super.key});

  @override
  State<Gardfawryview> createState() => _GardfawryviewState();
}

class _GardfawryviewState extends State<Gardfawryview> {
    final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
       key: key,
      drawer: MediaQuery.sizeOf(context).width < 600
          ? Customdrawer(drawerKey: drawerKey)
          : null,
      body: AdaptiveLayout(
        mobileLayout: (context) => const Gardviewmobilelayout(),
        tabletLayout: (context) => const Gardfawyscaffold(),
        desktopLayout: (context) => const Gardfawyscaffold(),
      ),
    );
  }
}


class Gardviewmobilelayout extends StatelessWidget {
  const Gardviewmobilelayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              color: Colors.amber,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_left_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          // Rest of your mobile layout
          const Expanded(
            child: Gard(), // Your main content goes here
          ),
        ],
      ),
    );
  }
}
