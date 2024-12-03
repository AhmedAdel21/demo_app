import 'package:e_commerce_shop/presentation/ui/common/base_viewmodel/base_viewmodel.dart';
import 'package:e_commerce_shop/presentation/ui/orders_graph/view/orders_graph_screen.dart';
import 'package:e_commerce_shop/presentation/ui/orders_summary/view/orders_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainViewModel extends BaseViewModel
    with ChangeNotifier
    implements _MainViewModelInputs, _MainViewModelOutputs {
  List<Widget> _widgetOptions = [];
  List<GButton> _tabs = [];
  int _selectedIndex = 0;
  @override
  void destroy() {}

  @override
  void start() {
    _tabs = const [
      GButton(
        icon: Icons.auto_graph_rounded,
        text: 'Graph',
        active: true,
        haptic: true,
        
        textStyle: TextStyle(fontSize:16), // Always display text
      ),
      GButton(
        icon: Icons.summarize_outlined,
        text: 'Summary',
        active: true,
        haptic: true,
        textStyle: TextStyle(fontSize:16), // Always display text
      ),
    ];
    _widgetOptions = const [
      OrderGraphScreen(),
      OrdersSummaryScreen(),
    ];
  }

  @override
  int get getSelectedIndex => _selectedIndex;

  @override
  Widget get getSelectedView {
    return _widgetOptions[_selectedIndex];
  }

  @override
  void setSelectedIndex(int newIndex) {
    if (_selectedIndex != newIndex) {
      _selectedIndex = newIndex;
      notifyListeners();
    }
  }

  @override
  List<GButton> get getTabs => _tabs;
}

abstract class _MainViewModelInputs {
  void setSelectedIndex(int newIndex);
}

abstract class _MainViewModelOutputs {
  int get getSelectedIndex;
  Widget get getSelectedView;
  List<GButton> get getTabs;
}
