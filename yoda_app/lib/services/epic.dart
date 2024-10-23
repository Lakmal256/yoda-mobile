import 'package:flutter/foundation.dart';
import 'services.dart';

class EpicViewServiceStore {
  List<EpicDto> epics;

  EpicViewServiceStore({
    this.epics = const [],
  });
}

class EpicViewService extends ValueNotifier<EpicViewServiceStore> {
  RestService restService;
  EpicViewService(this.restService) : super(EpicViewServiceStore());

  Future getEpicByProject(ProjectDto project) async {
    // notifyListeners();
  }
}
