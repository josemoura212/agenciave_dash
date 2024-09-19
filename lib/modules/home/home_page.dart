import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:agenciave_dash/modules/home/widgets/chart_widget.dart';
import 'package:agenciave_dash/modules/home/widgets/date_side_bar.dart';
import 'package:agenciave_dash/modules/home/widgets/up_bar.dart';
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

      await controller.getHomeData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          children: [
            const SizedBox(
              width: 250,
              child: DateSideBar(),
            ),
            Expanded(
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  const UpBar(),
                ],
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Watch(
                        (_) => Row(
                          children: [
                            ChartWidget(
                              title: "Origem das Vendas",
                              chartData: controller.origemData,
                            ),
                            ChartWidget(
                              title: "Estados",
                              chartData: controller.stateData,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Watch((_) => const SizedBox.shrink()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
