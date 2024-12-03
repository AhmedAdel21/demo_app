import 'package:e_commerce_shop/presentation/resources/models.dart';
import 'package:e_commerce_shop/presentation/styles/styles.dart';
import 'package:e_commerce_shop/presentation/ui/common/app_scaffold/app_scaffold.dart';
import 'package:e_commerce_shop/presentation/ui/orders_graph/viewmodel/orders_graph_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class OrderGraphScreen extends StatelessWidget {
  const OrderGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderGraphViewModel>(
      create: (context) => OrderGraphViewModel(),
      builder: ((context, child) {
        return const _OrderGraphScreenContent();
      }),
    );
  }
}

class _OrderGraphScreenContent extends StatefulWidget {
  const _OrderGraphScreenContent({super.key});

  @override
  State<_OrderGraphScreenContent> createState() =>
      __OrderGraphScreenContentState();
}

class __OrderGraphScreenContentState extends State<_OrderGraphScreenContent> {
  late final OrderGraphViewModel _viewModel;

  void _bind() {
    _viewModel = Provider.of<OrderGraphViewModel>(context, listen: false);
    _viewModel.start();
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  Widget get _contentWidget {
    return Selector<OrderGraphViewModel, SortingType>(
      selector: (_, provider) => provider.sortingType,
      builder: (context, value, child) {
        return Column(
          children: [
            androidAndIOSview,
            const SizedBox(height: 30),
            getButtons,
          ],
        );
      },
    );
  }

  Widget get _body {
    return StreamBuilder<DataState>(
      stream: _viewModel.onDataStateChanged,
      initialData: DataState.loading,
      builder: (context, AsyncSnapshot<DataState> snapshot) {
        if (snapshot.hasError) {
          return _getErrorWidget(
              snapshot.error?.toString() ?? AppStrings.errorHappened);
        }
        switch (snapshot.data) {
          case DataState.loading:
            return _waitingWidget;
          case DataState.data:
            return _contentWidget;
          case DataState.empty:
            return _emptyWidget;
          default:
            return _waitingWidget;
        }
      },
    );
  }

  Widget get _emptyWidget => Center(
          child: Text(
        AppStrings.noTasksFound,
        style: TextStylesManager.getBlackStyle(
          fontSize: FontSizeConstants.s22,
          color: AppColors.black,
        ),
      ));

  Widget get _waitingWidget => const Center(child: CircularProgressIndicator());

  Widget _getErrorWidget(String error) => Center(
          child: Text(
        error,
        style: TextStylesManager.getRegularStyle(
          color: AppColors.black,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      _body,
      _viewModel.getTitle,
    );
  }

  Widget get getButtons {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Choose Data Range",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: SortingType.values.map((type) {
            return ElevatedButton(
              onPressed: _viewModel.sortingType == type
                  ? null
                  : () {
                      _viewModel.setSortingMode(type);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    const Color.fromARGB(255, 133, 86, 141),
              ),
              child: Text(
                type.buttonLable,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget get androidAndIOSview {
    BoxConstraints? boxConstrain;
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;
    if (kIsWeb) {
      boxConstrain = const BoxConstraints(
        maxWidth: 800,
        maxHeight: 800,
        minHeight: 300,
        minWidth: 300,
      );
      crossAxisAlignment = CrossAxisAlignment.center;
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(
              'Orders Over Time',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              constraints: boxConstrain,
              child: AspectRatio(
                aspectRatio: 1.5,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        drawBelowEverything: true,
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval:
                              _viewModel.getGraphPointList.length > 10 ? 3 : 1,
                          // _viewModel.sortingType == SortingType.all ? 3 : 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 &&
                                index < _viewModel.getGraphPointList.length) {
                              return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 8.0,
                                  angle: 0.4,
                                  child: Text(
                                    _viewModel.getGraphPointList[index].date
                                        .toString()
                                        .substring(2),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }
                            return Container();
                          },
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            );
                          },
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 0.4)),
                    ),
                    minX: 0,
                    maxX: (_viewModel.getGraphPointList.length - 1).toDouble(),
                    minY: _viewModel.getMinY,
                    maxY: _viewModel.getMaxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _viewModel.getGraphPointList
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          GraphPoint data = entry.value;

                          return FlSpot(index.toDouble(), data.count);
                        }).toList(),
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 1.8,
                        // belowBarData: BarAreaData(
                        //     show: true, color: AppColors.primary.withOpacity(0.1)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
