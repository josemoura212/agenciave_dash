import 'package:agenciave_dash/core/ui/theme_manager.dart';
import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:agenciave_dash/modules/home/view/widgets/date_side_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:odometer/odometer.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class UpBar extends StatefulWidget {
  const UpBar({super.key});

  @override
  State<UpBar> createState() => _UpBarState();
}

class _UpBarState extends State<UpBar> {
  final controller = Injector.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.listenerCount();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Injector.get<ThemeManager>();

    return Watch(
      (_) => SliverAppBar(
        pinned: true,
        floating: true,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: controller.getData(GetData.showSettings) ? 125 : 90,
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
                  _PageToogle(
                    controller: controller,
                    title: "Cliente Novo Todo Dia",
                    product: Product.cd,
                    color: Colors.pinkAccent[400]!,
                    // colortText: Colors.black,
                  ),
                  _PageToogle(
                    controller: controller,
                    title: "Black é tudo de graça",
                    product: Product.black,
                    color: Colors.orangeAccent[400]!,
                    // colortText: Colors.black,
                  ),
                  Spacer(),
                  Visibility(
                    visible: controller.getData(GetData.selectedProduct) ==
                        Product.pe,
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
                  Visibility(
                    visible: controller.getData(GetData.selectedProduct) ==
                        Product.black,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: 250,
                      height: 45,
                      child: Center(
                        child: StreamBuilder(
                            stream: controller.channel,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Erro ao carregar os dados');
                              } else if (snapshot.hasData) {
                                final data = int.parse(snapshot.data);
                                return Row(
                                  children: [
                                    Text(
                                      "Contador: ",
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    AnimatedSlideOdometerNumber(
                                      odometerNumber: OdometerNumber(data),
                                      duration: Duration(seconds: 1),
                                      letterWidth: 10,
                                      numberTextStyle: TextStyle(
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Text('Sem dados');
                              }
                            }),
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
                          Text(
                              "Vendas: ${controller.getData(GetData.totalVendas)}"),
                          Text(
                              "Faturamento: ${controller.getData(GetData.totalFaturamento)}"),
                          Text(
                              "Receita: ${controller.getData(GetData.totalReceita)}"),
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
                                          if (controller.rangeEndDay != null &&
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
                            icon: Icon(controller.getData(GetData.showSettings)
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded),
                            onPressed: () {
                              controller.toggleShowHide(ShowAndHide.settings);
                            },
                            tooltip: "Abrir Configurações",
                          ),
                        ],
                      ),
                      Visibility(
                        visible: controller.getData(GetData.showSettings),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                              "Origem",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value:
                                  controller.getShowAndHide(ShowAndHide.origem),
                              onChanged: (_) =>
                                  controller.toggleShowHide(ShowAndHide.origem),
                            ),
                            Spacer(),
                            Text(
                              "Estados",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value:
                                  controller.getShowAndHide(ShowAndHide.state),
                              onChanged: (_) =>
                                  controller.toggleShowHide(ShowAndHide.state),
                            ),
                            Spacer(),
                            Text(
                              "Tipos de Pagamento",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller
                                  .getShowAndHide(ShowAndHide.paymentType),
                              onChanged: (_) => controller
                                  .toggleShowHide(ShowAndHide.paymentType),
                            ),
                            Spacer(),
                            Text(
                              "Tipos de Pagamento Oferta",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller
                                  .getShowAndHide(ShowAndHide.paymentTypeOffer),
                              onChanged: (_) => controller
                                  .toggleShowHide(ShowAndHide.paymentTypeOffer),
                            ),
                            Spacer(),
                            Text(
                              "Países",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller
                                  .getShowAndHide(ShowAndHide.country),
                              onChanged: (_) => controller
                                  .toggleShowHide(ShowAndHide.country),
                            ),
                            Spacer(),
                            Spacer(),
                            Text(
                              "Média de vendas",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller
                                  .getShowAndHide(ShowAndHide.gridMedia),
                              onChanged: (_) => controller
                                  .toggleShowHide(ShowAndHide.gridMedia),
                            ),
                            Spacer(),
                            Text(
                              "Dias da semana",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller
                                  .getShowAndHide(ShowAndHide.weekday),
                              onChanged: (_) => controller
                                  .toggleShowHide(ShowAndHide.weekday),
                            ),
                            Spacer(),
                            Text(
                              "Horas",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value:
                                  controller.getShowAndHide(ShowAndHide.hour),
                              onChanged: (_) =>
                                  controller.toggleShowHide(ShowAndHide.hour),
                            ),
                            Spacer(),
                            Text(
                              "Status",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value:
                                  controller.getShowAndHide(ShowAndHide.status),
                              onChanged: (_) =>
                                  controller.toggleShowHide(ShowAndHide.status),
                            ),
                            Spacer(),
                            Text(
                              "Recuperação",
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: controller
                                  .getShowAndHide(ShowAndHide.recovery),
                              onChanged: (_) => controller
                                  .toggleShowHide(ShowAndHide.recovery),
                            ),
                            Spacer(),
                            IconButton(
                              icon: const Icon(Icons.brightness_6),
                              onPressed: () {
                                themeManager.toggleTheme();
                              },
                              tooltip: "Mudar tema",
                            ),
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
              top: controller.getData(GetData.selectedProduct) == product
                  ? 10
                  : 5,
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
