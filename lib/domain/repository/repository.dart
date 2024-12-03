import 'package:dartz/dartz.dart' as dartz;
import 'package:e_commerce_shop/app/error/failure.dart';
import 'package:e_commerce_shop/domain/model/models.dart';

abstract class Repository {
  Future<void> initRepo();
  Future<dartz.Either<Failure, Map<String, Order>>> getOrders();
}
