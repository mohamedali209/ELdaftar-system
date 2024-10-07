
abstract class UpdateInventoryState {}

class UpdateInventoryInitial extends UpdateInventoryState {}

class UpdateInventoryLoading extends UpdateInventoryState {}

class UpdateInventorySuccess extends UpdateInventoryState {}

class UpdateInventoryFailure extends UpdateInventoryState {
  final String error;
  UpdateInventoryFailure({required this.error});
}
