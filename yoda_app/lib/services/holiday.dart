import 'package:flutter/foundation.dart';
import 'package:yoda_app/services/rest.dart';

import 'dto/holiday_dto.dart';

class HolidayViewServiceData {
  List<HolidayDto> holidays;
  DateTime? dateRangeStartDate;
  DateTime? dateRangeEndDate;

  HolidayViewServiceData({
    this.holidays = const [],
    this.dateRangeStartDate,
    this.dateRangeEndDate,
  });
}

class HolidayViewService extends ValueNotifier<HolidayViewServiceData> {
  RestService restService;

  HolidayViewService(this.restService) : super(HolidayViewServiceData());

  Future getHolidaysByDateRange(DateTime startDate, DateTime endDate) async {
    List<HolidayDto>? holidays = await restService.fetchHolidays(startDate, endDate);

    value
      ..dateRangeStartDate = startDate
      ..dateRangeEndDate = endDate
      ..holidays = holidays ?? [];
    notifyListeners();
  }

  Future getHolidaysByMonth(int year, {required int month}) async {
    await getHolidaysByDateRange(
      DateTime.utc(year, month, 1),
      // Providing a day value of zero for the next month
      // gives you the previous month's last day
      DateTime.utc(year, month + 1, 0),
    );
  }
}
