part of 'collectiondfater_cubit.dart';

abstract class CollectiondfaterState {}

class CollectiondfaterInitial extends CollectiondfaterState {}

class CollectiondfaterLoading extends CollectiondfaterState {}

class CollectiondfaterLoaded extends CollectiondfaterState {
  final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;
  final List<Expense> expenses; // Add expenses field
    final bool isLoading;


  CollectiondfaterLoaded({
        this.isLoading = false,

    required this.sellingItems,
    required this.buyingItems,
    required this.expenses, // Include expenses in the constructor
  });
}

class CollectiondfaterError extends CollectiondfaterState {
  final String errorMessage;

  CollectiondfaterError(this.errorMessage);
}
