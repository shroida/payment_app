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
      {required InitializePaymentSheetInputModel
          InitializePaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret:
            InitializePaymentSheetInputModel.clientSecret,
        customerEphemeralKeySecret:
            InitializePaymentSheetInputModel.ephemeralKeySecret,
        customerId: InitializePaymentSheetInputModel.customerId,
        merchantDisplayName: 'Shroida',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment({required PaymentIntentInputModel input}) async {
    final customerId = await createCustomer(email: input.email);

    final paymentIntentModel = await createPaymentIntent(
      PaymentIntentInputModel(
        email: customerId,
        amount: input.amount,
        currency: input.currency,
        customerId: customerId,
      ),
    );

    final ephemeralKeyModel = await createEphemeralKey(customerId: customerId);

    final initPaymentSheetInputModel = InitializePaymentSheetInputModel(
      clientSecret: paymentIntentModel.clientSecret!,
      customerId: customerId,
      ephemeralKeySecret: ephemeralKeyModel.secret!,
    );

    await initPaymentSheet(
        InitializePaymentSheetInputModel: initPaymentSheetInputModel);
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
