import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Watch(
      (_) => Visibility(
        visible: controller.selectedDay == null ||
            controller.rangeEndDay == null && controller.rangeStartDay == null,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Média de vendas diarias: ${controller.gridMediaData.mediaDiaria.vendas}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Média de faturamento diario: ${controller.gridMediaData.mediaDiaria.mediaFaturamento}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Média de receita diaria: ${controller.gridMediaData.mediaDiaria.mediaReceita}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Média de vendas mensais: ${controller.gridMediaData.mediaMensal.vendas}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Média de faturamento mensal: ${controller.gridMediaData.mediaMensal.mediaFaturamento}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Média de receita mensal: ${controller.gridMediaData.mediaMensal.mediaReceita}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
