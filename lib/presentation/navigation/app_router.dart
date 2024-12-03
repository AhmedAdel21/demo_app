import 'package:e_commerce_shop/presentation/ui/main/view/main_screen.dart';
import 'package:e_commerce_shop/presentation/ui/orders_graph/view/orders_graph_screen.dart';
import 'package:e_commerce_shop/presentation/ui/orders_summary/view/orders_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_commerce_shop/presentation/ui/splash_page/splash_page.dart';

class RoutesPath {
  static const splash = "/Splash";
  static const main = "/Main";
  static const ordersSummary = "/OrdersSummary";
  static const orderGraphScreen = "/OrderGraphScreen";
}

class RoutesName {
  static const splash = "Splash";
  static const main = "Main";
  static const ordersSummary = "OrdersSummary";
  static const orderGraphScreen = "orderGraphScreen";
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter();

  late final router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: false,
    initialLocation: RoutesPath.splash,
    routes: [
      //  Splash Page
      GoRoute(
        name: RoutesName.splash,
        path: RoutesPath.splash,
        builder: (context, state) => const SplashPage(),
      ),
      //  main Page
      GoRoute(
        name: RoutesName.main,
        path: RoutesPath.main,
        builder: (context, state) => const MainView(),
      ),
      //  Home Page
      GoRoute(
        name: RoutesName.ordersSummary,
        path: RoutesPath.ordersSummary,
        builder: (context, state) => const OrdersSummaryScreen(),
      ),
      //  Recipe details page
      GoRoute(
        name: RoutesName.orderGraphScreen,
        path: RoutesPath.orderGraphScreen,
        builder: (context, state) => const OrderGraphScreen(),
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
    redirect: (ctx, goRouterState) async {
      // final loggedIn = _appPreferences.getIsUserLoggedIn();

      // final loggingIn = goRouterState.location == RoutesPath.login;

      // if (!loggedIn) return loggingIn ? null : RoutesPath.login;

      return null;
    },
  );
}
