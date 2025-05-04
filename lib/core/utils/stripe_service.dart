import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_app/core/utils/api_service.dart';
import 'package:payment_app/core/utils/constants.dart';
import 'package:payment_app/features/payment/data/models/ephemeral_key_model/ephemeral_key_model.dart';
import 'package:payment_app/features/payment/data/models/init_payment_sheet_input_model.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_input_model.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_model.dart';

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      body: paymentIntentInputModel.toJson(),
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/payment_intents',
      token: Constants.secretKey,
    );

    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);

    return paymentIntentModel;
  }

  Future<String> createCustomer({required String email}) async {
    final response = await apiService.post(
      body: {'email': email},
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/customers',
      token: Constants.secretKey,
    );

    return response.data['id'];
  }

  Future initPaymentSheet(
      {required InitiPaymentSheetInputModel
          initiPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initiPaymentSheetInputModel.clientSecret,
        customerEphemeralKeySecret:
            initiPaymentSheetInputModel.ephemeralKeySecret,
        customerId: initiPaymentSheetInputModel.customerId,
        merchantDisplayName: 'tharwat',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment({required String email, required int amount}) async {
    final customerId = await createCustomer(email: email);

    var paymentIntentModel = await createPaymentIntent(
      PaymentIntentInputModel(
          amount: amount.toString(), currency: 'USD', customerId: customerId),
    );

    var ephemeralKeyModel = await createEphemeralKey(customerId: customerId);

    var initPaymentSheetInputModel = InitiPaymentSheetInputModel(
      clientSecret: paymentIntentModel.clientSecret!,
      customerId: customerId,
      ephemeralKeySecret: ephemeralKeyModel.secret!,
    );

    await initPaymentSheet(
        initiPaymentSheetInputModel: initPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemeralKey(
      {required String customerId}) async {
    var response = await apiService.post(
        body: {'customer': customerId},
        contentType: Headers.formUrlEncodedContentType,
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        token: Constants.secretKey,
        headers: {
          'Authorization': "Bearer ${Constants.secretKey}",
          'Stripe-Version': '2023-08-16',
        });

    var ephermeralKey = EphemeralKeyModel.fromJson(response.data);

    return ephermeralKey;
  }
}
