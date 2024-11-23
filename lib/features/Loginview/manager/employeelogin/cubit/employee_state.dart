
 class EmployeeState {
  const EmployeeState();
}

final class EmployeeInitial extends EmployeeState {}

final class EmployeeLoading extends EmployeeState {}

final class EmployeeSuccess extends EmployeeState {
  final String role;

  const EmployeeSuccess(this.role);
}

final class EmployeeFailure extends EmployeeState {
  final String errorMessage;

  const EmployeeFailure(this.errorMessage);
}
