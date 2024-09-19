import 'package:agenciave_dash/models/date_model.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';

class DateSideBar extends StatelessWidget {
  const DateSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Watch(
          (_) => SingleChildScrollView(
            child: Column(
              children: [
                Text("Total de Vendas: ${controller.homeData.length}"),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.dateData.length,
                  itemBuilder: (_, index) {
                    final date = controller.dateData[index];
                    return DateTile(
                      date: date,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  const DateTile({super.key, required this.date});

  final DateModel date;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${date.date.day}/${date.date.month}/${date.date.year} - ${date.weekday}",
      ),
      subtitle: Text("Total: ${date.total} vendas"),
    );
  }
}
