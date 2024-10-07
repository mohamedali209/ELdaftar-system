abstract class GardHeaderState {}

class GardHeaderInitial extends GardHeaderState {}

class GardHeaderLoading extends GardHeaderState {}

class GardHeaderLoaded extends GardHeaderState {
  final double total18kWeight;
  final double total21kWeight;
  final double totalinventoryWeight21;
  final double totalkKasr21;
  final double totalkKasr18;
  final double totalkKasrAll;
  final double sabekayekQuantity;
  final double sbaekayekWeight;
  final double totalinventoryAll;

  GardHeaderLoaded({
     required this.totalinventoryAll,
    required this.totalkKasrAll,
    required this.totalinventoryWeight21,
    required this.total18kWeight,
    required this.total21kWeight,
    required this.totalkKasr21,
    required this.totalkKasr18,
    required this.sabekayekQuantity,
    required this.sbaekayekWeight,
  });
}

class GardHeaderError extends GardHeaderState {
  final String message;

  GardHeaderError(this.message);
}
