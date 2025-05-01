import 'package:dartz/dartz.dart';

abstract class CheckoutRepo {
  Future<Either<Failure,void>> makePayment(){}
}
