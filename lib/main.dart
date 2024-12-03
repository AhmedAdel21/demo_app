import 'package:e_commerce_shop/app/app.dart';
import 'package:e_commerce_shop/app/di.dart';
import 'package:e_commerce_shop/presentation/styles/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await DI.initAppModule();
  runApp(EasyLocalization(
    supportedLocales: const [LanguageLocaleConstant.englishLocale],
    path: assetsPathLocalization,
    child: Phoenix(child: MyApp()),
  ));
}
