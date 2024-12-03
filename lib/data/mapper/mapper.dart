import 'package:e_commerce_shop/data/response/responses.dart';
import 'package:e_commerce_shop/domain/model/models.dart';
import "package:e_commerce_shop/app/extensions.dart";

extension OrderResponseMapper on OrderResponse {
  Order get toDomain {
    List<String> nullSafeTags = [];
    for (var tag in tags) {
      if (tag != null) {
        nullSafeTags.add(tag);
      }
    }
    return Order(
      id: id,
      isActive: isActive ?? false,
      price: price.orEmpty,
      company: company.orEmpty,
      picture: picture.orEmpty,
      buyer: buyer.orEmpty,
      tags: nullSafeTags,
      status: status.orEmpty,
      registered: registered,
    );
  }
}
