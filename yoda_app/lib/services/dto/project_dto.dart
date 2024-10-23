import 'user_dto.dart';

class ProjectDto {
  int? id;
  String? name;
  UserDto? manageBy;
  UserDto? technicalOwner;
  DateTime? expectedStartDate;
  DateTime? expectedEndDate;
  int? status;
  DateTime? createdDate;
  String? createdBy;
  DateTime? lastModifiedDate;
  String? lastModifiedBy;

  ProjectDto();

  factory ProjectDto.fromJson(Map<String, dynamic> data) {
    return ProjectDto()
      ..id = data["id"]
      ..name = data["name"]
      ..manageBy = UserDto.fromJson(data["manageBy"])
      ..technicalOwner = UserDto.fromJson(data["technicalOwner"])
      ..expectedStartDate = DateTime.tryParse(data["expectedStartDate"])
      ..expectedEndDate = DateTime.tryParse(data["expectedEndDate"])
      ..status = data["status"]
      ..createdDate = DateTime.tryParse(data["createdDate"])
      ..createdBy = data["createdBy"]
      ..lastModifiedDate = DateTime.tryParse(data["lastModifiedDate"])
      ..lastModifiedBy = data["lastModifiedBy"];
  }
}
