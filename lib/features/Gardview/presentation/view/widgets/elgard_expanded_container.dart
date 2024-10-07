import 'package:aldafttar/features/Gardview/presentation/view/widgets/dafarelgard.dart';
import 'package:aldafttar/features/Gardview/presentation/view/widgets/gard_header.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/utils/styles.dart';
import 'package:flutter/material.dart';

class Gard extends StatelessWidget {
  const Gard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < 600; // Adjust threshold as needed

    return Stack(
      children: [
        // Positioned image background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/Element.png', // Path to your image
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: 100, // Adjust height as needed
          ),
        ),
        // Content below the image
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  GardHeader(),
                  SizedBox(height: 20),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(
                thickness: 2,
                indent: 150,
                endIndent: 150,
                color: Color(0xffF7EAD1),
              ),
            ),
            SliverToBoxAdapter(
              child: Text('جرد فوري',
                  textDirection: TextDirection.rtl,
                  style: Appstyles.bold50(context)),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: isMobile
                    ? EdgeInsets.zero // No padding for mobile
                    : const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15), // Padding for larger screens,
                child: Custombackgroundcontainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 0, right: 0),
                      child: Container(
                        height: 600,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black,
                        ),
                        child: Stack(
                          children: [
                            const DaftarelGard(),
                            Positioned(
                              bottom: 10, // Position from the bottom
                              right: 10, // Position from the right
                              child: Image.asset(
                                'assets/images/undraw_heavy_box_agqi 1.png', // Path to your image
                                height: 300, // Adjust size as needed
                                width: 300, // Adjust size as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
