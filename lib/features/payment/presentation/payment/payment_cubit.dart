import 'dart:developer';

import 'package:payment_app/features/payment/data/models/payment_intent_input_model.dart';
import 'package:payment_app/features/payment/data/repos/checkout_repo.dart';
import 'package:payment_app/features/payment/presentation/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CheckoutRepo checkoutRepo;
  PaymentCubit(this.checkoutRepo) : super(PaymentInitial());

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    emit(PaymentLoading());
    var data = await checkoutRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel);
    data.fold((l) => emit(PaymentFailure(message: l.message)),
        (r) => emit(PaymentSuccess()));
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
