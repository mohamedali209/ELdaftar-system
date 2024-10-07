import 'package:aldafttar/features/Gardview/presentation/model/row_gard_model.dart';

abstract class ListGardState {}

class ListGardInitial extends ListGardState {}

class ListGardLoading extends ListGardState {}

class ListGardLoaded extends ListGardState {
  final List<Gardmodel> items;
  ListGardLoaded(this.items);
}

class ListGardError extends ListGardState {
  final String message;
  ListGardError(this.message);
}
