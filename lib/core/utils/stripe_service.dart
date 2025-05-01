import 'package:dio/dio.dart';
import 'package:payment_app/core/utils/api_service.dart';
import 'package:payment_app/core/utils/constants.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_input_model.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_model.dart';

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
}
