import 'package:agenciave_dash/modules/home/core/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  const Calendar(
      {super.key, required this.onDaySelected, required this.onRangeSelected});

  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime?, DateTime?, DateTime) onRangeSelected;

  @override
  Widget build(BuildContext context) {
    final controller = Injector.get<HomeController>();
    return Watch(
      (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(10),
                  isSelected: [
                    controller.getData(GetData.rangeSelectionMode) ==
                        RangeSelectionMode.toggledOff,
                    controller.getData(GetData.rangeSelectionMode) ==
                        RangeSelectionMode.toggledOn
                  ],
                  onPressed: (index) {
                    controller.onRangeSelectionModeChanged();
                  },
                  children: [
                    Tooltip(
                      message: "Seleção de data única",
                      child: const Icon(
                        Icons.calendar_today,
                      ),
                    ),
                    Tooltip(
                      message: "Seleção de intervalo",
                      child: const Icon(
                        Icons.date_range,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    controller.resetSelectedDate();
                  },
                  tooltip: "Resetar data",
                ),
              ],
            ),
            TableCalendar(
              locale: 'pt_BR',
              firstDay: controller.getData(GetData.dateData).first.date,
              lastDay: controller.getData(GetData.dateData).last.date,
              availableGestures: AvailableGestures.none,
              headerStyle: HeaderStyle(titleCentered: true),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: {CalendarFormat.month: "Month"},
              rangeSelectionMode:
                  controller.getData(GetData.rangeSelectionMode),
              focusedDay: controller.getData(GetData.focusDay),
              rangeStartDay: controller.getData(GetData.rangeStartDay),
              rangeEndDay: controller.getData(GetData.rangeEndDay),
              selectedDayPredicate: (day) =>
                  isSameDay(controller.getData(GetData.selectedDay), day),
              onDaySelected: onDaySelected,
              onRangeSelected: onRangeSelected,
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
              // onPageChanged: (focusedDay) {
              //   controller.focusedDay = focusedDay;
              // },
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
                rangeHighlightColor: Colors.orange.withOpacity(0.3),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
