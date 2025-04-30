import 'package:flutter/material.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/my_cart_view.dart';

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyCartView());
  }
}
