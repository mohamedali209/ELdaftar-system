import 'package:aldafttar/features/CollectionEldafaterview/manager/cubit/collectiondfater_cubit.dart';
import 'package:aldafttar/features/CollectionEldafaterview/view/widgets/collection_column_list.dart';
import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/custom_background_container.dart';
import 'package:aldafttar/features/daftarview/presentation/view/widgets/sellorbuy_items.dart';
import 'package:aldafttar/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionSellingWidget extends StatelessWidget {
  final Function(Daftarcheckmodel) onItemAdded;
  final List<Daftarcheckmodel> items;

  const CollectionSellingWidget({
    required this.onItemAdded,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the current route name

    return BlocBuilder<CollectiondfaterCubit, CollectiondfaterState>(
        builder: (context, state) {
      return _buildContent(context, state);
    });
  }

  Widget _buildContent(BuildContext context, dynamic state) {
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
                  // Show loading indicator if loading
                  if (state.isLoading)
                    const Center(
                      child: CustomLoadingIndicator(),
                    ),
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
                      const SliverToBoxAdapter(
                        child:
                            Divider(color: Color.fromARGB(255, 114, 110, 110)),
                      ),
                      const SliverToBoxAdapter(
                        child: Sellorbuyitems(),
                      ),
                      CollectionColumnDaftarlist(
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
