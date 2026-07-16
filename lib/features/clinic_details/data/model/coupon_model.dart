import 'package:clinic_app/features/clinic_details/domain/entites/coupon_entity.dart';
class CouponModel extends CouponEntity {
  const CouponModel({
    required super.originalPrice,
    required super.discountValue,
    required super.finalPrice,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic value) {
      if (value is num) return value;
      if (value is String) return num.tryParse(value) ?? 0;
      return 0;
    }

    return CouponModel(
      originalPrice: parseNum(json['original_price']),
      discountValue: parseNum(json['discount_value']),
      finalPrice: parseNum(json['final_price']),
    );
  }
}
