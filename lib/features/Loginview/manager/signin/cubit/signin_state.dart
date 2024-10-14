class SigninState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  SigninState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });
}
