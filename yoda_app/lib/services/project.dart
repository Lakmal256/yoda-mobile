import 'package:flutter/foundation.dart';
import 'services.dart';

class ProjectViewServiceStore {
  List<ProjectDto> projects;

  ProjectViewServiceStore({
    this.projects = const [],
  });
}

class ProjectViewService extends ValueNotifier<ProjectViewServiceStore> {
  RestService restService;
  ProjectViewService(this.restService) : super(ProjectViewServiceStore());

  Future getProjects() async {
    // notifyListeners();
  }
}
