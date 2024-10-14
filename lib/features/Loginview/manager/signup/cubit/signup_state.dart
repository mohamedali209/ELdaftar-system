class SignupState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  SignupState({this.isLoading = false, this.errorMessage, this.isSuccess = false});
}