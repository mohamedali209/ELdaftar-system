part of 'collectiondfater_cubit.dart';

abstract class CollectiondfaterState {}

class CollectiondfaterInitial extends CollectiondfaterState {}

class CollectiondfaterLoaded extends CollectiondfaterState {
  final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;

  CollectiondfaterLoaded({required this.sellingItems, required this.buyingItems});
}
class CollectiondfaterLoading extends CollectiondfaterState{}
class CollectiondfaterError extends CollectiondfaterState {
  final String errorMessage;

  CollectiondfaterError(this.errorMessage);
}
