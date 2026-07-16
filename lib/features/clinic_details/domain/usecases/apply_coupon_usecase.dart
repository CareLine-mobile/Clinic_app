import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entites/coupon_entity.dart';
import '../repositories/clinic_repository.dart';

class ApplyCouponUseCase {
  final ClinicRepository repository;

  ApplyCouponUseCase(this.repository);

  Future<Either<Failure, CouponEntity>> call(String coupon, String clinicalId) {
    return repository.applyCoupon(coupon, clinicalId);
  }
}
