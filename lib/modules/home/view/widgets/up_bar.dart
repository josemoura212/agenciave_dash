import 'package:agenciave_dash/core/ui/theme_manager.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:agenciave_dash/modules/home/view/widgets/date_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class UpBar extends StatelessWidget {
  const UpBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Injector.get<ThemeManager>();
    final controller = Injector.get<HomeController>();

    return Watch(
      (_) => SliverAppBar(
        pinned: true,
        floating: true,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: controller.showSettings ? 125 : 90,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  _PageToogle(
                    controller: controller,
                    title: "Vendas Internas",
                    product: Product.vi,
                    color: Colors.greenAccent[400]!,
                    colortText: Colors.black,
                  ),
                  _PageToogle(
                    controller: controller,
                    title: "Stories Intencionais",
                    product: Product.si,
                    color: Colors.purpleAccent[400]!,
                  ),
                  _PageToogle(
                    controller: controller,
                    title: "Profissão Expert",
                    product: Product.pe,
                    color: Colors.yellowAccent[700]!,
                    colortText: Colors.black,
                  ),
                  Spacer(),
                  Visibility(
                    visible: controller.selectedProduct == Product.pe,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent[400],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controller.changeRelease(false);
                            },
                            tooltip: "Lançamento Anterior",
                          ),
                          Text(
                            "Lançamento: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controller.changeRelease(true);
                            },
                            tooltip: "Lançamento Posterior",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Card(
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Vendas: ${controller.totalVendas}"),
                          Text("Faturamento: ${controller.totalFaturamento}"),
                          Text("Receita: ${controller.totalReceita}"),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              controller.resetSelectedDate();
                            },
                            tooltip: "Resetar data",
                          ),
                          IconButton(
                            icon: controller.selectedDay != null ||
                                    controller.rangeEndDay != null &&
                                        controller.rangeStartDay != null
                                ? Text(
                                    "Data selecionada: ${controller.selectedDayFormatted}")
                                : Icon(Icons.calendar_today),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: SizedBox(
                                    height: 400,
                                    width: 350,
                                    child: Calendar(
                                      onDaySelected: (selectedDay, focusedDay) {
                                        if (!isSameDay(controller.selectedDay,
                                            selectedDay)) {
                                          controller.onDaySelected(
                                              selectedDay, focusedDay);
                                          Navigator.pop(context);
                                        }
                                      },
                                      onRangeSelected:
                                          (start, end, focusedDay) {
                                        if (controller.rangeStartDay != null &&
                                            controller.rangeEndDay != null) {
                                          return;
                                        } else {
                                          controller.onRangeSelected(
                                              start, end, focusedDay);
                                          if (controller.rangeStartDay !=
                                                  null &&
                                              controller.rangeEndDay != null) {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            tooltip: "Selecionar data",
                          ),
                          IconButton(
                            icon: Icon(controller.showSettings
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded),
                            onPressed: () {
                              controller.toogleSettings();
                            },
                            tooltip: "Abrir Configurações",
                          ),
                        ],
                      ),
                      Visibility(
                        visible: controller.showSettings,
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                              "Origem",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller.showOrigen,
                              onChanged: (_) => controller.toogleOrigen(),
                            ),
                            Spacer(),
                            Text(
                              "Estados",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller.showState,
                              onChanged: (_) => controller.toogleState(),
                            ),
                            Spacer(),
                            IconButton(
                              icon: const Icon(Icons.brightness_6),
                              onPressed: () {
                                themeManager.toggleTheme();
                              },
                              tooltip: "Mudar tema",
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageToogle extends StatelessWidget {
  const _PageToogle({
    required this.controller,
    required this.title,
    required this.product,
    required this.color,
    this.colortText,
  });

  final HomeController controller;
  final String title;
  final Product product;
  final Color color;
  final Color? colortText;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => InkWell(
        onTap: () async {
          await controller.changeProduct(product);
        },
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          padding: EdgeInsets.only(
              top: controller.selectedProduct == product ? 10 : 5,
              bottom: 5,
              left: 10,
              right: 10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colortText ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
