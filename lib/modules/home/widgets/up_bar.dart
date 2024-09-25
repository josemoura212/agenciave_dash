import 'package:agenciave_dash/core/ui/theme_manager.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';

class UpBar extends StatelessWidget {
  const UpBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Injector.get<ThemeManager>();
    final controller = Injector.get<HomeController>();

    return SliverAppBar(
      pinned: true,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Card(
          child: Watch(
            (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      controller.resetSelectedDate();
                    },
                    tooltip: "Resetar data",
                  ),
                  Text("Vendas: ${controller.totalVendas}"),
                  Text("Faturamento: ${controller.totalFaturamento}"),
                  Text("Receita: ${controller.totalReceita}"),
                  Visibility(
                    visible: controller.selectedDate != null,
                    child: Text("Data: ${controller.selectedDate}"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        controller.setSelectedDate(pickedDate);
                      }
                    },
                    tooltip: "Selecionar data",
                  ),
                  IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () {
                      // Logic to toggle theme
                      themeManager.toggleTheme();
                    },
                    tooltip: "Mudar tema",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
