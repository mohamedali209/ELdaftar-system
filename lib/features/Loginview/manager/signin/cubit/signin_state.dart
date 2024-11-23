class SigninState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic>? storeData;
  final String? shopId;

  const SigninState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.storeData,
    this.shopId,
  });
}
