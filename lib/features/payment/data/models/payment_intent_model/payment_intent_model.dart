class PaymentIntentModel {
  int? amount;

  String? clientSecret;
  String? currency;

  PaymentIntentModel({
    this.amount,
    this.clientSecret,
    this.currency,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      amount: json['amount'] as int?,
      clientSecret: json['client_secret'] as String?,
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'client_secret': clientSecret,
        'currency': currency,
      };
}
