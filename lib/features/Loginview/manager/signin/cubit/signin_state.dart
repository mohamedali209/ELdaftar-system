class SigninState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic>? storeData; // Add storeData field
  final String? shopId; // Add shopId to state

  SigninState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.storeData,
    this.shopId,
  });
}
