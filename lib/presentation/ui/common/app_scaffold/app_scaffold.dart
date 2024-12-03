import 'package:e_commerce_shop/presentation/styles/styles.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  const AppScaffold(this.child, this.title, {super.key});

  AppBar customAppBar() {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: FontSizeConstants.s24,
          color: Colors.white,
          letterSpacing: 0.53,
        ),
      ),
      backgroundColor: AppColors.primary,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(90),
      //   ),
      // ),
      // bottom: PreferredSize(
      //     preferredSize: const Size.fromHeight(0.0),
      //     child: Padding(
      //       padding: const EdgeInsets.only(bottom: 15.0),
      //       child: Text(
      //         title,
      //         style: const TextStyle(
      //           fontWeight: FontWeight.bold,
      //           fontSize: 24,
      //           color: Colors.white,
      //           letterSpacing: 0.53,
      //         ),
      //       ),
      //     )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(),
        backgroundColor: const Color.fromARGB(255, 252, 248, 253),
        body: child,
      ),
    );
  }
}
