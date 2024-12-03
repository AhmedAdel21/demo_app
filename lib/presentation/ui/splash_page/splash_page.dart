import 'dart:async';

import 'package:e_commerce_shop/presentation/navigation/app_navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_shop/app/di.dart';
import 'package:e_commerce_shop/presentation/navigation/app_router.dart';
import 'package:e_commerce_shop/presentation/styles/styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashPageContent();
  }
}

class _SplashPageContent extends StatefulWidget {
  const _SplashPageContent();

  @override
  State<_SplashPageContent> createState() => __SplashPageContentState();
}

class __SplashPageContentState extends State<_SplashPageContent> {
  Timer? _timer;

  void _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  void _goNext() {
    // bool isUserLoggedIn =
    //     DI.getItInstance<AppSharedPrefs>().getIsUserLoggedIn();
    // if (isUserLoggedIn) {
    // navigate to home page
    DI
        .getItInstance<AppNavigationManager>()
        .navigateToPageAsFirstRoute(RoutesName.main);
    // } else {
    //   // navigate to login page
    //
    // }
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          child: _body,
        ),
      ),
    );
  }

  Widget get _body {
    return Center(
        child: SizedBox(
      height: AppSizeConstants.s200,
      width: AppSizeConstants.s200,
      child: Image.asset(GifAssets.appLogo),
    ));
  }
}
