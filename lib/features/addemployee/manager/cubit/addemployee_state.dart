

abstract class AddEmployeeState {}

class AddEmployeeInitial extends AddEmployeeState {}

class AddEmployeeLoading extends AddEmployeeState {}

class AddEmployeeSuccess extends AddEmployeeState {}

class AddEmployeeError extends AddEmployeeState {
  final String message;

  AddEmployeeError(this.message);
}
class AddEmployeeLoaded extends AddEmployeeState {
  final List<Map<String, dynamic>> employees;

  AddEmployeeLoaded(this.employees);
}