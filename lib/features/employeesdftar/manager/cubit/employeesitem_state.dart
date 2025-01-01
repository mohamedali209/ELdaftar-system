import 'package:aldafttar/features/daftarview/presentation/view/models/daftar_check_model.dart';
import 'package:equatable/equatable.dart';

class EmployeesitemState extends Equatable {
  final List<Daftarcheckmodel> sellingItems;
  final List<Daftarcheckmodel> buyingItems;
  final String employeeName;
  final bool isLoading;

  const EmployeesitemState({
    required this.sellingItems,
    required this.buyingItems,
    this.employeeName = '',
    this.isLoading = false,
  });

  @override
  List<Object> get props =>
      [sellingItems, buyingItems, isLoading, employeeName];

  // Method to copy the state with modified values
  EmployeesitemState copyWith({
    List<Daftarcheckmodel>? sellingItems,
    List<Daftarcheckmodel>? buyingItems,
    String? employeeName,
    bool? isLoading,
  }) {
    return EmployeesitemState(
      sellingItems: sellingItems ?? this.sellingItems,
      buyingItems: buyingItems ?? this.buyingItems,
      isLoading: isLoading ?? this.isLoading,
      employeeName: employeeName ?? this.employeeName,
    );
  }
}
