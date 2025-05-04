import 'package:payment_app/core/utils/api_service.dart';
import 'package:payment_app/core/utils/constants.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_input_model.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentModel) async {
    var response = await apiService.post(
      url: 'https://api.stripe.com/v1/payment_intents',
      token: Constants.secretKey,
      body: paymentModel.toJson(),
    );
    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);
    return paymentIntentModel;
  }

  Future initPaymentSheet({required String paymentIntentClientSecret}) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: 'Muhammad Walied'));
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment({required PaymentIntentInputModel paymentModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentModel);

    await initPaymentSheet(
        paymentIntentClientSecret: paymentIntentModel.clientSecret!);

    await displayPaymentSheet();
  }
}
