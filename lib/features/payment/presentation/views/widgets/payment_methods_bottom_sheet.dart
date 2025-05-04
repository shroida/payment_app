import 'package:flutter/material.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/custom_button_bloc_consumer.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/payment_methods_list_view.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {
  final String totalPrice; 

  const PaymentMethodsBottomSheet({super.key, required this.totalPrice});

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  bool isPaypal = false;

  updatePaymentMethod({required int index}) {
    if (index == 0) {
      isPaypal = false;
    } else {
      isPaypal = true;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          PaymentMethodsListView(
            updatePaymentMethod: updatePaymentMethod,
          ),
          const SizedBox(
            height: 32,
          ),
          CustomButtonBlocConsumer(
            totalPrice: widget.totalPrice,
            isPaypal: isPaypal,
          ),
        ],
      ),
    );
  }
}
