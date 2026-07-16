import 'package:clinic_app/features/clinic_details/domain/entites/coupon_entity.dart';
class CouponModel extends CouponEntity {
  const CouponModel({
    required super.originalPrice,
    required super.discountValue,
    required super.finalPrice,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      originalPrice: json['original_price'] ?? 0,
      discountValue: json['discount_value'] ?? 0,
      finalPrice: json['final_price'] ?? 0,
    );
  }
}
