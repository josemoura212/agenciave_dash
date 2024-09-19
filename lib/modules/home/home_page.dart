import 'package:agenciave_dash/core/helpers/messages.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:agenciave_dash/modules/home/widgets/date_side_bar.dart';
import 'package:agenciave_dash/modules/home/widgets/origem_chart.dart';
import 'package:agenciave_dash/modules/home/widgets/up_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';

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
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: DateSideBar(),
            ),
            Expanded(
              child: Column(
                children: [
                  UpBar(),
                  OrigemChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
