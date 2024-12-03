import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:e_commerce_shop/app/constants/global_constants.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

class DioFactory {
  DioFactory();
  Future<Dio> get getDio async {
    Dio dio = Dio();

    // String appLanguage = _appPreferences.getAppLanguage();

    Map<String, String> header = {
      contentType: applicationJson,
      accept: applicationJson,
      authorization: Constants.dummyToken,
      // defaultLanguage: appLanguage
    };

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: header,
      sendTimeout: Constants.apiRequestTimeOut,
      receiveTimeout: Constants.apiRequestTimeOut,
    );

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true));
    }

    return dio;
  }
}
