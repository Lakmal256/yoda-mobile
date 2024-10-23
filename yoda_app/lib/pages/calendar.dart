import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yoda_app/services/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yoda_app/widgets/widgets.dart';

import '../locator.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime pageDate;
  late Future fetchAction;

  Future fetchHolidays(DateTime date) => locate<HolidayViewService>().getHolidaysByMonth(
        date.year,
        month: date.month,
      );

  handlePageDateChange(DateTime date) {
    setState(() {
      pageDate = date;
      fetchAction = fetchHolidays(date);
    });
  }

  @override
  void initState() {
    pageDate = DateTime.now();
    fetchAction = fetchHolidays(pageDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: "Calendar View"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConcreteCalendar(
              onPageChange: handlePageDateChange,
              focusedDay: pageDate,
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15).copyWith(left: 20),
              child: Text(
                "Holidays - ${DateFormat.yMMMM().format(pageDate)}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            FutureBuilder(
              future: fetchAction,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }

                return const SizedBox.shrink();
              },
            ),
            const HolidayList(),
          ],
        ),
      ),
    );
  }
}

class CustomTableCalendarBuilders extends CalendarBuilders {
  CustomTableCalendarBuilders()
      : super(
          headerTitleBuilder: (context, date) => Center(
            child: Text(
              DateFormat.yMMMM().format(date),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          dowBuilder: (context, date) => Text(
            DateFormat.E().format(date).toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        );
}

class ConcreteCalendar extends StatelessWidget {
  const ConcreteCalendar({
    Key? key,
    required this.onPageChange,
    required this.focusedDay,
  }) : super(key: key);

  final Function(DateTime date) onPageChange;
  final DateTime focusedDay;

  bool holidayPredicate(DateTime date) =>
      locate<HolidayViewService>().value.holidays.any((holiday) => DateUtils.isSameDay(holiday.date!, date),);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: locate<HolidayViewService>(),
      builder: (context, _) {
        return TableCalendar(
          focusedDay: focusedDay,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(5000, 01, 01),
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          calendarFormat: CalendarFormat.month,
          currentDay: DateTime.now(),
          daysOfWeekHeight: 25,
          holidayPredicate: holidayPredicate,
          calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(0.5),
              holidayTextStyle: const TextStyle(color: Colors.white),
              holidayDecoration: const BoxDecoration(color: Color(0xff4974A5)),
              todayTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              todayDecoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              tablePadding: const EdgeInsets.symmetric(horizontal: 15),
              weekendTextStyle: const TextStyle(color: Colors.white),
              weekendDecoration: const BoxDecoration(color: Colors.black26)),
          calendarBuilders: CustomTableCalendarBuilders(),
          onPageChanged: onPageChange,
        );
      },
    );
  }
}

class HolidayList extends StatelessWidget {
  const HolidayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locate<HolidayViewService>(),
      builder: (context, value, _) {
        return Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 15),
            shrinkWrap: true,
            children: value.holidays
                .map(
                  (holiday) => HolidayListItem(
                    date: holiday.date,
                    description: holiday.name ?? "N/A",
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class HolidayListItem extends StatelessWidget {
  HolidayListItem({
    super.key,
    required this.date,
    required this.description,
    DateFormat? dFormat,
  }) : dFormat = dFormat ?? DateFormat.yMMMd();

  final DateTime? date;
  final String description;
  final DateFormat dFormat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            if (date != null)
              TextSpan(
                text: "${dFormat.format(date!)} - ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }
}
