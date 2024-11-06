import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:equatable/equatable.dart';

class ItemsState extends Equatable {
  final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;
  final bool isLoading;

  const ItemsState({
    required this.sellingItems,
    required this.buyingItems,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [sellingItems, buyingItems, isLoading];

  // Method to copy the state with modified values
  ItemsState copyWith({
    List<Daftarcheckmodel>? sellingItems,
    List<Daftarcheckmodel>? buyingItems,
    bool? isLoading,
  }) {
    return ItemsState(
      sellingItems: sellingItems ?? this.sellingItems,
      buyingItems: buyingItems ?? this.buyingItems,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
