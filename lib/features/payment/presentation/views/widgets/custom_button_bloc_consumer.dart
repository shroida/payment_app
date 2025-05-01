import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_app/core/utils/constants.dart';
import 'package:payment_app/core/widget/custom_button.dart';
import 'package:payment_app/features/payment/data/models/payment_intent_model/payment_intent_input_model.dart';
import 'package:payment_app/features/payment/presentation/payment/payment_cubit.dart';
import 'package:payment_app/features/payment/presentation/payment/payment_state.dart';
import 'package:payment_app/features/payment/presentation/views/my_cart_view.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/thank_you_view.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({
    super.key,
    required this.isPaypal,
  });

  final bool isPaypal;
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
    PaymentIntentInputModel paymentIntentInputModel = PaymentIntentInputModel(
      amount: '100',
      currency: 'USD',
      cusomerId: 'cus_Onu3Wcrzhehlez',
    );
    BlocProvider.of<PaymentCubit>(context)
        .makePayment(paymentIntentInputModel: paymentIntentInputModel);
  }

  void exceutePaypalPayment(BuildContext context,
      ({AmountModel amount, ItemListModel itemList}) transctionsData) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: Constants.clientID,
        secretKey: Constants.paypalSecretKey,
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
              return const MyCartView();
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
