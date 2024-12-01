part of 'collection_modify_cubit.dart';

 class CollectionModifyState extends Equatable {
 final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;
  final bool isLoading;

  const CollectionModifyState({
    required this.sellingItems,
    required this.buyingItems,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [sellingItems, buyingItems, isLoading];

  // Method to copy the state with modified values
  CollectionModifyState copyWith({
    List<Daftarcheckmodel>? sellingItems,
    List<Daftarcheckmodel>? buyingItems,
    bool? isLoading,
  }) {
    return CollectionModifyState(
      sellingItems: sellingItems ?? this.sellingItems,
      buyingItems: buyingItems ?? this.buyingItems,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

