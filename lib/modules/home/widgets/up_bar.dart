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
      floating: true,
      snap: true,
      pinned: true,
      backgroundColor: Colors.grey.shade900,
      surfaceTintColor: Colors.grey.shade900,
      elevation: 12,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Watch(
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
    );
  }
}
