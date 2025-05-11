import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:payment_app/core/widget/custom_button.dart';
import 'package:payment_app/core/widget/cutom_app_bar.dart';
import 'package:payment_app/features/payment/data/repos/checkout_repo_impl.dart';
import 'package:payment_app/features/payment/presentation/payment/payment_cubit.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/cart_info_item.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/payment_methods_bottom_sheet.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/total_price_widget.dart';

class MyCartViewBody extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double shipping;

  const MyCartViewBody({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.shipping,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal - discount + shipping;

    return Scaffold(
      appBar: buildAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Expanded(child: Image.asset('assets/images/controller.jpg')),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Subtotal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                discount > 0
                    ? Row(
                        children: [
                          Text(
                            '${subtotal.toStringAsFixed(2)}\$',
                            style: const TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(subtotal - discount).toStringAsFixed(2)}\$',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '${subtotal.toStringAsFixed(2)}\$',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 3),
            const SizedBox(height: 3),
            OrderInfoItem(
              title: 'Discount',
              value: '${discount.toStringAsFixed(2)}\$',
            ),
            const SizedBox(height: 3),
            OrderInfoItem(
              title: 'Shipping',
              value: '${shipping.toStringAsFixed(2)}\$',
            ),
            const Divider(
              thickness: 2,
              height: 34,
              color: Color(0xffC7C7C7),
            ),
            TotalPrice(
              title: 'Total',
              value: '${total.toStringAsFixed(2)}\$',
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Complete Payment',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => PaymentCubit(CheckoutRepoImpl()),
                      child: PaymentMethodsBottomSheet(
                        totalPrice: total.toStringAsFixed(2),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
