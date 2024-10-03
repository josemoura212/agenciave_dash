import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/models/chart_model.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:agenciave_dash/modules/home/view/widgets/chart_widget.dart';
import 'package:agenciave_dash/modules/home/view/widgets/cartesian_widget.dart';
import 'package:agenciave_dash/modules/home/view/widgets/table_widget.dart';
import 'package:agenciave_dash/modules/home/view/widgets/up_bar.dart';
import 'package:agenciave_dash/modules/home/view/widgets/weekday_widget.dart';
import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MessageViewMixin {
  final controller = Injector.get<HomeController>();

  @override
  void initState() {
    messageListener(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final logged = await controller.isAuthenticaded();
      if (!logged) {
        Navigator.pushNamedAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          "/splash",
          (_) => false,
        );
      }

      await controller.getHomeData().asyncLoader();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: controller.getHomeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const UpBar(),
              ],
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Watch(
                      (_) => Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          Visibility(
                            visible: controller.showOrigen,
                            child: ChartWidget(
                              title: "Origem das Vendas",
                              chartData: controller.origemData,
                            ),
                          ),
                          Visibility(
                            visible: controller.showState,
                            child: ChartWidget(
                              title: "Estados",
                              chartData: controller.stateData,
                            ),
                          ),
                          Visibility(
                            visible: controller.showPaymentType,
                            child: ChartWidget(
                              title: "Tipo de Pagamento",
                              chartData: controller.paymentTypeData,
                            ),
                          ),
                          Visibility(
                            visible: controller
                                .getShowAndHide(ShowAndHide.paymentTypeOffer),
                            child: ChartWidget(
                              title: "Tipos de Pagamento Oferta",
                              chartData: controller.getData<List<ChartModel>>(
                                      GetData.paymentTypeOfferData)
                                  as List<ChartModel>,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: TableWidget()),
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        WeekdayWidget(),
                        CartesianWidget(
                          title: "Vendas por hora",
                          tooltip: "Vendas",
                          data: GetData.hourData,
                        )
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Row(
                      children: [
                        CartesianWidget(
                          title: "Status de compra",
                          tooltip: "Status",
                          data: GetData.status,
                        ),
                        CartesianWidget(
                          title: "Status de compra",
                          tooltip: "Status",
                          data: GetData.status,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
