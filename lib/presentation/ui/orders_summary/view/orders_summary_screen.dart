import 'package:e_commerce_shop/presentation/resources/models.dart';
import 'package:e_commerce_shop/presentation/styles/styles.dart';
import 'package:e_commerce_shop/presentation/ui/common/app_scaffold/app_scaffold.dart';
import 'package:e_commerce_shop/presentation/ui/orders_summary/viewmodel/orders_summary_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersSummaryScreen extends StatelessWidget {
  const OrdersSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrdersSummaryViewModel>(
      create: (context) => OrdersSummaryViewModel(),
      builder: ((context, child) {
        return const _OrdersSummaryScreenContent();
      }),
    );
  }
}

class _OrdersSummaryScreenContent extends StatefulWidget {
  const _OrdersSummaryScreenContent({super.key});

  @override
  State<_OrdersSummaryScreenContent> createState() =>
      __OrdersSummaryScreenContentState();
}

class __OrdersSummaryScreenContentState
    extends State<_OrdersSummaryScreenContent> {
  late final OrdersSummaryViewModel _viewModel;

  void _bind() {
    _viewModel = Provider.of<OrdersSummaryViewModel>(context, listen: false);
    _viewModel.start();
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  Widget _buildMetricCard(String title, String value, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.9), accentColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget get contentWidget {
    return androidAndIOSview;
  }

  Widget get androidAndIOSview {
    BoxConstraints? boxConstrain;
    if (kIsWeb) {
      boxConstrain = const BoxConstraints(
        maxWidth: 800,
        maxHeight: 800,
        minHeight: 300,
        minWidth: 300,
      );
    }
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: boxConstrain,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildMetricCard('Total Orders',
                _viewModel.getTotalOrdersCounts.toString(), AppColors.primary),
            const SizedBox(height: 16),
            _buildMetricCard(
                'Average Price',
                '\$${_viewModel.getOrdersAveragePrice.toStringAsFixed(2)}',
                const Color.fromARGB(255, 31, 145, 34)),
            const SizedBox(height: 16),
            _buildMetricCard(
                'Returns',
                _viewModel.getNumberOfReturns.toString(),
                const Color.fromARGB(255, 194, 51, 40)),
            const SizedBox(height: 30),
            // PieChartSample2(),
            ReturnsPieChart(
              totalOrders: _viewModel.getTotalOrdersCounts,
              returns: _viewModel.getNumberOfReturns,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _body {
    return StreamBuilder<DataState>(
      stream: _viewModel.onDataStateChanged,
      initialData: DataState.loading,
      builder: (context, AsyncSnapshot<DataState> snapshot) {
        switch (snapshot.data) {
          case DataState.loading:
            return waitingWidget;
          case DataState.data:
            return contentWidget;
          case DataState.empty:
            return emptyWidget;
          case DataState.error:
            return getErrorWidget(
                snapshot.error?.toString() ?? AppStrings.errorHappened);
          default:
            return waitingWidget;
        }
      },
    );
  }

  Widget get emptyWidget => Center(
          child: Text(
        AppStrings.noTasksFound,
        style: TextStylesManager.getBlackStyle(
          fontSize: FontSizeConstants.s22,
          color: AppColors.black,
        ),
      ));

  Widget get waitingWidget => const Center(child: CircularProgressIndicator());

  Widget getErrorWidget(String error) => Center(
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
}

class ReturnsPieChart extends StatefulWidget {
  final int totalOrders;
  final int returns;

  const ReturnsPieChart({
    required this.totalOrders,
    required this.returns,
    super.key,
  });

  @override
  State<ReturnsPieChart> createState() => _ReturnsPieChartState();
}

class _ReturnsPieChartState extends State<ReturnsPieChart> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Orders Breakdown',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: _buildPieSections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 0,
                      borderData: FlBorderData(show: false),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: Color.fromARGB(255, 194, 51, 40),
                      text: 'RETURNED',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color.fromARGB(255, 31, 145, 34),
                      text: 'DELIVERED',
                      isSquare: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> get _buildPieSections {
    int numberOfDelivered = widget.totalOrders - widget.returns;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            value: numberOfDelivered.toDouble(),
            title:
                '${((numberOfDelivered / widget.totalOrders) * 100).toStringAsFixed(1)}%',
            color: const Color.fromARGB(255, 31, 145, 34),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            value: widget.returns.toDouble(),
            title:
                '${((widget.returns / widget.totalOrders) * 100).toStringAsFixed(1)}%',
            color: const Color.fromARGB(255, 194, 51, 40),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
