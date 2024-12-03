import 'dart:convert';

import 'package:e_commerce_shop/data/network/rest_api/app_api.dart';
import 'package:e_commerce_shop/data/response/responses.dart';
import 'package:flutter/services.dart';

abstract class RemoteDataSource {
  Future<List<OrderResponse>> getOrders();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<List<OrderResponse>> getOrders() => _appServiceClient.getOrders();
}

class RemoteDataSourceMockImpl implements RemoteDataSource {
  RemoteDataSourceMockImpl();

  @override
  Future<List<OrderResponse>> getOrders() async {
    String jsonString = await rootBundle.loadString('assets/orders.json');

    final List<dynamic> jsonResponse = json.decode(jsonString);

    return jsonResponse.map((data) => OrderResponse.fromJson(data)).toList();
  }
}
