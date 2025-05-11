class InitializePaymentSheetInputModel {
  final String clientSecret;
  final String customerId;
  final String ephemeralKeySecret;

  InitializePaymentSheetInputModel(
      {required this.clientSecret,
      required this.customerId,
      required this.ephemeralKeySecret});
}
