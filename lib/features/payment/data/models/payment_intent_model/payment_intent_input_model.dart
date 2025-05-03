// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaymentIntentInputModel {
  final String amount;
  final String currency;
  final String cusomerId;

  PaymentIntentInputModel({
    required this.amount,
    required this.currency,
    required this.cusomerId,
  });

  toJson() {
    return {
      'amount': amount,
      'cusomer_id': cusomerId,
      'currency': currency,
    };
  }
}
