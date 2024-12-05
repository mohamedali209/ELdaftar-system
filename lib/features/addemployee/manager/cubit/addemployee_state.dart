abstract class AddEmployeecubitState {}

class AddEmployeeInitial extends AddEmployeecubitState {}

class AddEmployeeLoading extends AddEmployeecubitState {}

class AddEmployeeSuccess extends AddEmployeecubitState {}

class AddEmployeeError extends AddEmployeecubitState {
  final String message;

  AddEmployeeError(this.message);
}

class AddEmployeeLoaded extends AddEmployeecubitState {
  final List<Map<String, dynamic>> employees;

  AddEmployeeLoaded(this.employees);
}
