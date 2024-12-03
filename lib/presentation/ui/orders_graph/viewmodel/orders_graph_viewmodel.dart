import 'dart:async';

import 'package:e_commerce_shop/app/di.dart';
import 'package:e_commerce_shop/app/global_functions.dart';
import 'package:e_commerce_shop/domain/model/models.dart';
import 'package:e_commerce_shop/domain/usecase/usecase.dart';
import 'package:e_commerce_shop/presentation/resources/models.dart';
import 'package:e_commerce_shop/presentation/ui/common/base_viewmodel/base_viewmodel.dart';
import 'package:flutter/foundation.dart';

enum SortingType {
  last6Month("Last 6 Months"),
  lastYear("Last Year"),
  all("All"),
  ;

  final String buttonLable;
  const SortingType(this.buttonLable);
}

class OrderGraphViewModel extends BaseViewModel
    with ChangeNotifier
    implements _OrderGraphViewModelInputs, _OrderGraphViewModelOutputs {
  final StreamController<DataState> _dataStateSC =
      StreamController<DataState>();

  /// Map< id : Order >
  Map<String, Order> _orders = {};

  List<MapEntry<OrderDate, int>> sortedOrders = [];
  List<GraphPoint> _returnedList = [];

  double _minY = 0;
  double _maxY = 0;

  SortingType sortingType = SortingType.all;

  @override
  String get getTitle => 'Order Graph';

  @override
  void start() {
    _getAllOrders();
  }

  void _getAllOrders() async {
    _dataStateSC.add(DataState.loading);
    // await Future.delayed(const Duration(seconds: 2));
    (await DI.getItInstance<GetOrdersUsecase>().execute(null)).fold((left) {
      securePrint("left: $left");
      _dataStateSC.addError(left.message);
      // _dataStateSC.add(DataState.error);
    }, (right) {
      _orders = right;
      securePrint("_orders: $_orders");
      _processOrders();
      if (_orders.isEmpty) {
        _dataStateSC.add(DataState.empty);
      } else {
        _dataStateSC.add(DataState.data);
      }
    });
  }

  void _processOrders() {
    Map<OrderDate, int> ordersByDate = {};
    for (var order in _orders.values) {
      final DateTime? date = order.registered?.toLocal();
      if (date != null) {
        OrderDate orderDate = OrderDate(date.year, date.month, date.day);
        ordersByDate[orderDate] = (ordersByDate[orderDate] ?? 0) + 1;
      }
    }

    /// date: count
    sortedOrders = ordersByDate.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    _processGraphOrders();
  }

  void _processGraphOrders() {
    _minY = 0;
    _maxY = 0;
    DateTime? date;
    switch (sortingType) {
      case SortingType.last6Month:
        date = DateTime.now().subtract(const Duration(days: 30 * 6));
        break;
      case SortingType.lastYear:
        date = DateTime.now().subtract(const Duration(days: 30 * 12));
        break;
      case SortingType.all:
        break;
    }
    sortedOrders.forEach(securePrint);
    securePrint("date: $date");
    _returnedList = sortedOrders.where((item) {
      OrderDate orderDate = item.key;
      if (date == null) return true;
      securePrint("orderDate.getDate: ${orderDate.getDate}");
      return orderDate.getDate.isAfter(date);
    }).map((item) {
      int count = item.value;

      if (_minY == 0) {
        _minY = count.toDouble();
      }

      if (_minY > count) {
        _minY = count.toDouble();
      }
      if (count > _maxY) {
        _maxY = count.toDouble();
      }

      return GraphPoint(
          "${item.key.getYear}/${item.key.getMonth}", count.toDouble());
    }).toList();

    if (_minY != 0) {
      _minY--;
    }

    if (_maxY != 0) {
      _maxY++;
    }
    _returnedList.forEach(securePrint);
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
  List<GraphPoint> get getGraphPointList {
    return _returnedList;
  }

  @override
  Stream<DataState> get onDataStateChanged => _dataStateSC.stream;

  @override
  double get getMaxY => _maxY;

  @override
  double get getMinY => _minY;

  @override
  void setSortingMode(SortingType mode) {
    sortingType = mode;
    _processGraphOrders();
    notifyListeners();
  }
}

abstract class _OrderGraphViewModelInputs {
  void setSortingMode(SortingType mode);
}

abstract class _OrderGraphViewModelOutputs {
  Stream<DataState> get onDataStateChanged;

  // List<Order> get getOrdersList;
  List<GraphPoint> get getGraphPointList;
  double get getMinY;
  double get getMaxY;
  String get getTitle;
}

class GraphPoint {
  final String date;
  final double count;
  const GraphPoint(this.date, this.count);

  @override
  String toString() => "GraphPoint(date: $date, count: $count)";
}

class OrderDate implements Comparable<OrderDate> {
  final int year;
  final int month;
  final int day;

  const OrderDate(this.year, this.month, this.day);

  DateTime get getDate => DateTime(year, month, day);

  @override
  String toString() => "OrderDate(year: $year, month: $month, day: $day)";
  @override
  int get hashCode => (year + month).hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDate &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month;

  @override
  int compareTo(OrderDate other) {
    if (other.year.compareTo(year) != 0) {
      return other.year.compareTo(year);
    }
    if (other.month.compareTo(month) != 0) {
      return other.month.compareTo(month);
    }
    // if (other.day.compareTo(day) != 0) {
    //   return other.day.compareTo(day);
    // }
    return 0;
  }

  String get getYear => year.toString();
  String get getMonth => month.toString().padLeft(2, "0");
  String get getDay => day.toString().padLeft(2, "0");
}
// class OrderSpot extends FlSpot {
//   OrderSpot(super.x, super.y);

//   factory OrderSpot.fromOrder(Order order){
// return OrderSpot (order.registered!.millisecondsSinceEpoch.toDouble(),order.)
//   }
// }
