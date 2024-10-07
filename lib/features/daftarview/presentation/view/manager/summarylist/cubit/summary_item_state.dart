import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_header_model.dart';

// Define the states
abstract class SummaryDftarState {}

class SummaryDftarInitial extends SummaryDftarState {}

class SummaryDftarLoading extends SummaryDftarState {}

class SummaryDftarLoaded extends SummaryDftarState {
  final List<DaftarheaderModel> items;

  SummaryDftarLoaded(this.items);
}

class SummaryDftarError extends SummaryDftarState {
  final String message;

  SummaryDftarError(this.message);
}
