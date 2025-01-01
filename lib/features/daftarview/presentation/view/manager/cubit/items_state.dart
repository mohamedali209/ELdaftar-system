import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:equatable/equatable.dart';

class ItemsState extends Equatable {
  final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;
  final bool isLoading;
  final String storeName;

  const ItemsState({
    required this.sellingItems,
    required this.buyingItems,
    this.storeName = '',
    this.isLoading = false,
  });

  @override
  List<Object> get props => [sellingItems, buyingItems, isLoading, storeName];

  // Method to copy the state with modified values
  ItemsState copyWith({
    List<Daftarcheckmodel>? sellingItems,
    List<Daftarcheckmodel>? buyingItems,
    String? storeName,
    bool? isLoading,
  }) {
    return ItemsState(
      sellingItems: sellingItems ?? this.sellingItems,
      buyingItems: buyingItems ?? this.buyingItems,
      isLoading: isLoading ?? this.isLoading,
      storeName: storeName ?? this.storeName,
    );
  }
}
