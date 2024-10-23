class HolidayDto {
  int? id;
  DateTime? date;
  String? name;
  int? type;
  int? period;

  HolidayDto();

  factory HolidayDto.fromJson(Map<String, dynamic> data) {
    return HolidayDto()
      ..id = data["id"]
      ..date = DateTime.tryParse(data["calendarDate"])
      ..name = data["name"]
      ..type = data["type"]
      ..period = data["period"];
  }
}
