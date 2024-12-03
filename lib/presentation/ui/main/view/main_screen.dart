import 'package:e_commerce_shop/presentation/styles/styles.dart';
import 'package:e_commerce_shop/presentation/ui/main/viewmodel/main_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainViewModel>(
      create: (context) => MainViewModel(),
      builder: ((context, child) {
        return const _MainViewContent();
      }),
    );
  }
}

class _MainViewContent extends StatefulWidget {
  const _MainViewContent({super.key});

  @override
  State<_MainViewContent> createState() => __MainViewContentState();
}

class __MainViewContentState extends State<_MainViewContent> {
  late final MainViewModel _viewModel;

  void _bind() {
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    _viewModel.start();
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  Widget get _body {
    return Row(
      children: [
        if (kIsWeb) getWebDrawer,
        Expanded(
          child: _viewModel.getSelectedView,
        )
      ],
    );
  }

  Widget get getWebDrawer {
    return Drawer(
      width: 200,
      shape: const RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: AppColors.primary,
                shape: BoxShape.rectangle,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph_rounded),
            title: const Text('Graph'),
            onTap: () {
              _viewModel.setSelectedIndex(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.summarize_outlined),
            title: const Text('Summary'),
            onTap: () {
              _viewModel.setSelectedIndex(1);
            },
          ),
        ],
      ),
    );
  }

  Widget _navigationBar(int index) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: GNav(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        rippleColor: const Color.fromARGB(255, 210, 116, 226),
        hoverColor: const Color.fromARGB(255, 202, 135, 216),
        gap: 8,
        activeColor: Colors.white,
        iconSize: 25,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        duration: const Duration(milliseconds: 400),
        tabBackgroundColor: const Color.fromARGB(255, 194, 79, 214),
        backgroundColor: AppColors.primary,
        color: Colors.white,
        tabs: const [
          GButton(
            icon: Icons.auto_graph_rounded,
            text: 'Graph',
            textStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          GButton(
            icon: Icons.summarize_outlined,
            text: 'Summary',
            textStyle: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
        selectedIndex: index,
        onTabChange: (index) => _viewModel.setSelectedIndex(index),
        tabBorderRadius: 40,
      ),
    );
  }

  PreferredSizeWidget getTopNavBar(int index) {
    return AppBar(
      backgroundColor: AppColors.primary,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: _navigationBar(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Selector<MainViewModel, int>(
        selector: (_, provider) => provider.getSelectedIndex,
        builder: (context, index, child) {
          return Scaffold(
            extendBody: false,
            // drawer: (kIsWeb) ? getWebDrawer : null,
            drawerEnableOpenDragGesture: true,
            backgroundColor: const Color.fromARGB(255, 252, 248, 253),
            body: _body,
            bottomNavigationBar: (!kIsWeb) ? _navigationBar(index) : null,
          );
        },
      ),
    );
  }
}
