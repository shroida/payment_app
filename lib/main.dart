import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_app/core/utils/constants.dart';
import 'package:payment_app/payment_app.dart';

void main() {
  Stripe.publishableKey = Constants.publishKey;
  runApp(const PaymentApp());
}
