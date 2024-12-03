import 'dart:async';

import 'package:e_commerce_shop/app/di.dart';
import 'package:e_commerce_shop/domain/model/models.dart';
import 'package:e_commerce_shop/domain/usecase/usecase.dart';
import 'package:e_commerce_shop/presentation/resources/models.dart';
import 'package:e_commerce_shop/presentation/ui/common/base_viewmodel/base_viewmodel.dart';
import 'package:flutter/foundation.dart';

class OrdersSummaryViewModel extends BaseViewModel
    with ChangeNotifier
    implements _OrdersSummaryInputs, _OrdersSummaryOutputs {
  final StreamController<DataState> _dataStateSC =
      StreamController<DataState>();

  Map<String, Order> _orders = {};
  int _numberOfReturns = 0;
  double _averagePrice = 0;
  @override
  String get getTitle => 'Order Metrics';

  @override
  void start() {
    _getAllOrders();
  }

  void _getAllOrders() async {
    _dataStateSC.add(DataState.loading);
    // await Future.delayed(const Duration(seconds: 2));
    (await DI.getItInstance<GetOrdersUsecase>().execute(null)).fold((left) {
      _dataStateSC.add(DataState.error);
    }, (right) {
      _orders = right;
      _processOrder();
      if (_orders.isEmpty) {
        _dataStateSC.add(DataState.empty);
      } else {
        _dataStateSC.add(DataState.data);
      }
    });
  }

  void _processOrder() {
    _averagePrice = 0;
    _numberOfReturns = 0;
    for (var order in _orders.values) {
      if (order.status == 'RETURNED') {
        _numberOfReturns++;
      }
      _averagePrice +=
          double.parse(order.price.replaceAll("\$", "").replaceAll(",", ""));
    }
    _averagePrice / _orders.length;
  }

  @override
  void destroy() {
    _dataStateSC.close();
  }

  @override
  void dispose() {
    destroy();
    super.dispose();
  }

  @override
  List<Order> get getTodoTasks => _orders.values.toList();

  @override
  Stream<DataState> get onDataStateChanged => _dataStateSC.stream;

  @override
  int get getNumberOfReturns => _numberOfReturns;
  @override
  double get getOrdersAveragePrice => _averagePrice;

  @override
  int get getTotalOrdersCounts => _orders.length;

  @override
  int get getNumberOfDelivered => getTotalOrdersCounts - getNumberOfReturns;
}

abstract class _OrdersSummaryInputs {}

abstract class _OrdersSummaryOutputs {
  Stream<DataState> get onDataStateChanged;

  List<Order> get getTodoTasks;

  int get getTotalOrdersCounts;
  double get getOrdersAveragePrice;
  int get getNumberOfReturns;
  int get getNumberOfDelivered;

  String get getTitle;
}
