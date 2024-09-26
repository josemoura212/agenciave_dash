import 'package:agenciave_dash/models/date_model.dart';
import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSideBar extends StatelessWidget {
  const DateSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Card(
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Watch(
            (_) => SingleChildScrollView(
              child: Column(
                children: [
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
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  DateTile({super.key, required this.date});

  final DateModel date;
  final HomeController controller = Injector.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // controller.setSelectedDate(date.date);
      },
      title: Text(
        "${date.date.day}/${date.date.month}/${date.date.year} - ${date.weekday}",
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        "Total: ${date.total} vendas",
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final controller = Injector.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) {
        print(
            "============================== CALENDAR ==============================");
        return TableCalendar(
          locale: 'pt_BR',
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2018),
          lastDay: DateTime.utc(2030),
          availableGestures: AvailableGestures.none,
          headerStyle: HeaderStyle(titleCentered: true),
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: {CalendarFormat.month: "Month"},
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          onRangeSelected: (start, end, focusedDay) {
            setState(() {
              controller.setSelectedDate(start, end);
            });
          },
          selectedDayPredicate: (day) {
            print("==============================");
            return isSameDay(
                controller.selectedStartDate, controller.selectedEndDate);
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              color: Colors.white,
            ),
            rangeStartDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            withinRangeDecoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            withinRangeTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
