import 'package:equatable/equatable.dart';

class CouponEntity extends Equatable {
  final num originalPrice;
  final num discountValue;
  final num finalPrice;

  const CouponEntity({
    required this.originalPrice,
    required this.discountValue,
    required this.finalPrice,
  });

  @override
  List<Object?> get props => [originalPrice, discountValue, finalPrice];
}
