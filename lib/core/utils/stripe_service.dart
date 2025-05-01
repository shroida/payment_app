import 'package:dio/dio.dart';
import 'package:payment_app/core/utils/api_service.dart';
import 'package:payment_app/core/utils/constants.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_input_model.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final Dio dio = Dio();
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentInten(
      PaymentIntentInputModel paymentModel) async {
    var response = await apiService.post(
      body: paymentModel.toJson(),
      url: 'https://api.stripe.com/v1/payment_intents',
      token: Constants.secretKey,
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
    Stripe.instance.presentPaymentSheet();
  }

  Future makePayment({required PaymentIntentInputModel paymentModel}) async {
    var paymentIntentModel = await createPaymentInten(paymentModel);

    await initPaymentSheet(
        paymentIntentClientSecret: paymentIntentModel.clientSecret!);

    await displayPaymentSheet();
  }
}
