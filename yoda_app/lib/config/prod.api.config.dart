import 'package:yoda_app/rest.dart';

class RestConfigProd implements RestConfig{
  @override
  String get authority => "20.205.13.142:8081";

  @override
  String get users => "/api/users";

  @override
  String get usersCurrent => "/api/users/current";

  @override
  String get usersByRole =>  "/api/users/role";

  @override
  String get projects => "/api/project";

  @override
  String get epics => "/api/epics";

  @override
  String get timeLogs => "/api/time-logs";

  @override
  String get fileUpload => "/api/file/upload";

  @override
  String get fileDownload => "/api/file/download";

  @override
  String get holidays => "/api/holidays";
}