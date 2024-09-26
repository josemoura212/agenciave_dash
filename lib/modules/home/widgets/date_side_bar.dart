import 'package:agenciave_dash/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

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
        return TableCalendar(
          locale: 'pt_BR',
          firstDay: controller.dateData.first.date,
          lastDay: controller.dateData.last.date,
          availableGestures: AvailableGestures.none,
          headerStyle: HeaderStyle(titleCentered: true),
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: {CalendarFormat.month: "Month"},
          rangeSelectionMode: controller.rangeSelectionMode,
          focusedDay: controller.focusedDay,
          rangeStartDay: controller.rangeStartDay,
          rangeEndDay: controller.rangeEndDay,
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(controller.selectedDay, selectedDay)) {
              controller.onDaySelected(selectedDay, focusedDay);
            }
          },
          onRangeSelected: (start, end, focusedDay) {
            controller.onRangeSelected(start, end, focusedDay);
          },
          selectedDayPredicate: (day) => isSameDay(controller.selectedDay, day),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            weekendStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          calendarStyle: CalendarStyle(
            disabledDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            disabledTextStyle: const TextStyle(
              color: Colors.transparent,
            ),
            defaultTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            weekendTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.deepOrange,
            ),
            rangeStartDecoration: BoxDecoration(
              color: Colors.orange, // Cor de fundo para o início do intervalo
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Colors.orange, // Cor de fundo para o fim do intervalo
              shape: BoxShape.circle,
            ),
            withinRangeDecoration: BoxDecoration(
              color: Colors.orange.withOpacity(
                  0.5), // Cor de fundo para os dias dentro do intervalo
              shape: BoxShape.circle,
            ),
            rangeHighlightColor: Colors.orange
                .withOpacity(0.3), // Cor de destaque para o intervalo
            selectedDecoration: BoxDecoration(
              color: Colors.deepOrange, // Cor de fundo para o dia selecionado
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.orangeAccent, // Cor de fundo para o dia atual
              shape: BoxShape.circle,
            ),
          ),
          // calendarStyle: CalendarStyle(
          //   todayDecoration: BoxDecoration(
          //     color: Colors.orange,
          //     shape: BoxShape.circle,
          //   ),
          //   todayTextStyle: const TextStyle(
          //     color: Colors.white,
          //   ),
          //   rangeStartDecoration: BoxDecoration(
          //     color: Colors.orange,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(50),
          //       bottomLeft: Radius.circular(50),
          //     ),
          //   ),
          //   rangeEndDecoration: BoxDecoration(
          //     color: Colors.orange,
          //     borderRadius: BorderRadius.only(
          //       topRight: Radius.circular(50),
          //       bottomRight: Radius.circular(50),
          //     ),
          //   ),
          //   withinRangeDecoration: BoxDecoration(
          //     color: Colors.orange.withOpacity(0.5),
          //     shape: BoxShape.circle,
          //   ),
          //   withinRangeTextStyle: TextStyle(
          //     color: Colors.white,
          //   ),
          // ),
        );
      },
    );
  }
}
