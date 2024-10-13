part of 'modifying_cubit.dart';

 class ModifyingState extends Equatable {
 final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;

  const ModifyingState({required this.sellingItems, required this.buyingItems});

  @override
  List<Object> get props => [sellingItems, buyingItems];
}
