import 'package:aldafttar/features/marmatview/model/marmat_model.dart';

// Base state class
abstract class MarmatState {}

// Initial state when the feature is first loaded
class MarmatInitial extends MarmatState {}

// State while loading data (e.g., from Firestore)
class MarmatLoading extends MarmatState {}

// State representing loaded data
class MarmatLoaded extends MarmatState {
  final List<MarmatModel> items;

  MarmatLoaded({required this.items});

  // Method to create a new state with an updated list of items
  MarmatLoaded copyWith({List<MarmatModel>? items}) {
    return MarmatLoaded(
      items: items ?? this.items,
    );
  }
}

// State representing an error that occurred during operations
class MarmatError extends MarmatState {
  final String message;

  MarmatError({required this.message});
}
