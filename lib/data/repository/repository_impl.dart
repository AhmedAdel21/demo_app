import 'dart:async';

import 'package:e_commerce_shop/data/data_source/local_data_source/run_time_cache_data_source.dart';
import 'package:e_commerce_shop/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:e_commerce_shop/data/mapper/mapper.dart';
import 'package:e_commerce_shop/data/network/error_handler.dart';
import 'package:e_commerce_shop/data/network/network_info.dart';
import 'package:e_commerce_shop/app/error/failure.dart';
import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:e_commerce_shop/data/response/responses.dart';
import 'package:e_commerce_shop/domain/model/models.dart';
import 'package:e_commerce_shop/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final RunTimeCacheDataSource _runTimeCache;
  RepositoryImpl(this._remoteDataSource, this._networkInfo, this._runTimeCache);

  @override
  Future<void> initRepo() async {}

  @override
  Future<Either<Failure, Map<String, Order>>> getOrders() async {
    try {
      final orderList = _runTimeCache.getOrders();
      return Right(orderList);
    } catch (e) {
      if (await _networkInfo.isConnected) {
        try {
          List<OrderResponse> response = await _remoteDataSource.getOrders();

          Map<String, Order> orderList = Map.fromEntries(
            response.map((res) => MapEntry(res.id, res.toDomain)),
          );

          _runTimeCache.saveOrders(orderList);

          return Right(orderList);
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // failure -- return either left, internet connection error
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }
}

class RepositoryErrorCodesConstant {
  static const localDataSourceErrorCode = 5000;
}
