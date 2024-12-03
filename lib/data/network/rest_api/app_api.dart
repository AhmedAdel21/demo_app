import 'package:dio/dio.dart';
import 'package:e_commerce_shop/data/network/network_constants.dart';
import 'package:e_commerce_shop/data/response/responses.dart';
import 'package:retrofit/http.dart';
import 'package:e_commerce_shop/app/constants/global_constants.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @GET(ServerPaths.orders)
  Future<List<OrderResponse>> getOrders();
}
