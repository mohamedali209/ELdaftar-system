
abstract class FetchInsightsState {}

class FetchInsightsInitial extends FetchInsightsState {}

class FetchInsightsLoading extends FetchInsightsState {}

class FetchInsightsSuccess extends FetchInsightsState {
  final List<double> salesData;
  final List<double> purchaseData;  // Add purchase data

  FetchInsightsSuccess(this.salesData, this.purchaseData);
}


class FetchInsightsFailure extends FetchInsightsState {
  final String error;
  FetchInsightsFailure(this.error);
}
