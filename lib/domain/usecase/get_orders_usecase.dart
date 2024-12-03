part of 'usecase.dart';

class GetOrdersUsecase implements BaseUseCase<void, Map<String, Order>> {
  final Repository _repository;

  GetOrdersUsecase(this._repository);

  @override
  Future<Either<Failure, Map<String, Order>>> execute(void input) =>
      _repository.getOrders();
}
