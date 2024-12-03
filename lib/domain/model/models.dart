import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required bool isActive,
    required String price,
    required String company,
    required String picture,
    required String buyer,
    required List<String> tags,
    required String status,
    required DateTime? registered,
  }) = _Order;

  factory Order.fromJson(Map<String, Object?> json) => _$OrderFromJson(json);
}
