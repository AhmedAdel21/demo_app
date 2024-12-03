import 'package:e_commerce_shop/app/constants/global_constants.dart';
import 'package:e_commerce_shop/data/network/error_handler.dart';
import 'package:e_commerce_shop/domain/model/models.dart';

abstract class RunTimeCacheDataSource {
  void saveOrders(Map<String, Order> orderList);
  Map<String, Order> getOrders();

  void clearCache();
}

enum _CacheKeys { orderList }

class _CacheItemsInterval {
  static const orderList = Constants.defaultCacheInterval;
}

double _getCacheInterval(_CacheKeys key) {
  switch (key) {
    case _CacheKeys.orderList:
      return _CacheItemsInterval.orderList.toDouble();
  }
}

class RunTimeCacheDataSourceImpl implements RunTimeCacheDataSource {
  // run time cache
  final Map<_CacheKeys, CachedItem> _cacheMap = {};

  void _saveToCache(_CacheKeys key, CachedItem item) => _cacheMap[key] = item;

  T _getData<T>(_CacheKeys key) {
    CachedItem? cachedItem = _cacheMap[key];
    if (cachedItem != null && cachedItem.isValid(_getCacheInterval(key))) {
      return cachedItem.data as T;
    } else {
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  void saveOrders(Map<String, Order> orderList) =>
      _saveToCache(_CacheKeys.orderList, CachedItem(orderList));

  @override
  void clearCache() => _cacheMap.clear();

  @override
  Map<String, Order> getOrders() =>
      _getData<Map<String, Order>>(_CacheKeys.orderList);
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(double expirationTime) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    bool returnValue = (currentTime - cacheTime) <= expirationTime;
    return returnValue;
  }
}
