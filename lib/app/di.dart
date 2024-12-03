import 'package:e_commerce_shop/data/data_source/local_data_source/run_time_cache_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:e_commerce_shop/domain/repository/repository.dart';
import 'package:e_commerce_shop/domain/usecase/usecase.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_shop/data/data_source/local_data_source/permanent_data_source/app_shared_prefs.dart';
import 'package:e_commerce_shop/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:e_commerce_shop/data/network/dio_factory.dart';
import 'package:e_commerce_shop/data/network/network_info.dart';
import 'package:e_commerce_shop/data/network/rest_api/app_api.dart';
import 'package:e_commerce_shop/data/repository/repository_impl.dart';
import 'package:e_commerce_shop/presentation/navigation/app_navigation_manager.dart';

class DI {
  static final _instance = GetIt.instance;

  static GetIt get getItInstance => _instance;
  static Future<void> initAppModule() async {
    // shared prefs _instance
    final sharedPrefs = await SharedPreferences.getInstance();
    _instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

    // app prefs
    _instance.registerLazySingleton<AppSharedPrefs>(
        () => AppSharedPrefsImpl(_instance()));

    // network info
    _instance.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(InternetConnection()));

    // dio factory
    _instance.registerLazySingleton<DioFactory>(() => DioFactory());

    // app service client
    final dio = await _instance<DioFactory>().getDio;
    _instance
        .registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

    // _instance.registerLazySingleton<RemoteDataSource>(
    //     () => RemoteDataSourceImpl(_instance()));

    _instance.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSourceMockImpl());
    _instance.registerLazySingleton<RunTimeCacheDataSource>(
        () => RunTimeCacheDataSourceImpl());

    // init repo
    _instance.registerLazySingleton<Repository>(
        () => RepositoryImpl(_instance(), _instance(), _instance()));
    await _instance<Repository>().initRepo();

    _initUseCases();

    // App Navigation Manager
    _instance.registerLazySingleton<AppNavigationManager>(
        () => AppNavigationManagerImpl());
  }

  static void _initUseCases() {
    _instance.registerLazySingleton<GetOrdersUsecase>(
        () => GetOrdersUsecase(_instance()));
  }
}
