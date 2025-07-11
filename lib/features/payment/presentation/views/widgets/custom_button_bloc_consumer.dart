import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment_app/core/functions/get_transactions.dart';
import 'package:payment_app/core/widget/custom_button.dart';
import 'package:payment_app/features/payment/data/models/amount_model/amount_model.dart';
import 'package:payment_app/features/payment/data/models/item_list_model/item_list_model.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_input_model.dart';
import 'package:payment_app/features/payment/presentation/payment/payment_cubit.dart';
import 'package:payment_app/features/payment/presentation/payment/payment_state.dart';
import 'package:payment_app/features/payment/presentation/views/my_cart_view.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/thank_you_view.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  final String totalPrice;

  final bool isPaypal;
  const CustomButtonBlocConsumer({
    super.key,
    required this.isPaypal,
    required this.totalPrice,
  });
  final userEmail = "walied@example.com";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const ThankYouView();
          }));
        }

        if (state is PaymentFailure) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(content: Text(state.message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
            onTap: () {
              if (isPaypal) {
                var transctionsData = getTransctionsData();
                exceutePaypalPayment(context, transctionsData);
              } else {
                excuteStripePayment(context);
              }
            },
            isLoading: state is PaymentLoading ? true : false,
            text: 'Continue');
      },
    );
  }

  void excuteStripePayment(BuildContext context) {
    final cleanedAmount =
        (double.tryParse(totalPrice.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0) *
            100;
    final amountAsInt = cleanedAmount.toInt().toString();

    PaymentIntentInputModel paymentIntentInputModel = PaymentIntentInputModel(
      amount: amountAsInt,
      email: userEmail,
      currency: 'USD',
    );

    BlocProvider.of<PaymentCubit>(context)
        .makePayment(paymentIntentInputModel: paymentIntentInputModel);
  }

  void exceutePaypalPayment(BuildContext context,
      ({AmountModel amount, ItemListModel itemList}) transctionsData) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: 'Constants.clientID',
        secretKey: 'Constants.paypalSecretKey',
        transactions: [
          {
            "amount": transctionsData.amount.toJson(),
            "description": "The payment transaction description.",
            "item_list": transctionsData.itemList.toJson(),
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const ThankYouView();
            }),
            (route) {
              if (route.settings.name == '/') {
                return true;
              } else {
                return false;
              }
            },
          );
        },
        onError: (error) {
          SnackBar snackBar = SnackBar(content: Text(error.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const MyCartListView();
            }),
            (route) {
              return false;
            },
          );
        },
        onCancel: () {
          print('cancelled:');
          Navigator.pop(context);
        },
      ),
    ));
  }
}
