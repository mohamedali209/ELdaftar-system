class SigninState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic>? storeData; // Add storeData field

  SigninState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.storeData,
  });
}
