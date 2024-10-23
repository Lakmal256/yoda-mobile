import 'package:flutter/foundation.dart';

import 'project_dto.dart';

class EpicDto {
  int? id;
  ProjectDto? project;
  String? epicName;
  String? epicDescription;

  EpicDto();

  factory EpicDto.fromJson(Map<String, dynamic> data) {
    return EpicDto()
      ..id = data["id"]
      ..project = ProjectDto.fromJson(data["project"])
      ..epicName = data["epicName"]
      ..epicDescription = data["epicDescription"];
  }
}