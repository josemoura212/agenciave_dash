import 'package:agenciave_dash/models/cartesian_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianWidget extends StatelessWidget {
  const CartesianWidget(
      {super.key,
      required this.title,
      required this.tooltip,
      required this.data});
  final String title;
  final String tooltip;
  final GetData data;

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Expanded(
      child: Watch(
        (_) => SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: ChartTitle(text: title),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            header: tooltip,
          ),
          series: [
            ColumnSeries<CartesianModel, String>(
              dataSource: controller.getData<List<CartesianModel>>(data)
                  as List<CartesianModel>,
              xValueMapper: (CartesianModel data, _) => data.value,
              yValueMapper: (CartesianModel data, _) => data.quantity,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
