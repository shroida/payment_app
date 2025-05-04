import 'package:flutter/material.dart';
import 'package:payment_app/core/widget/cutom_app_bar.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/my_cart_view_body.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: 'My Cart'),
        body: const MyCartViewBody(
          subtotal: 220.97,
          discount: 70.0,
          shipping: 8.0,
        ));
  }
}
