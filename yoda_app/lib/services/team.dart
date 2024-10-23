import 'package:flutter/foundation.dart';
import 'package:yoda_app/services/services.dart';

enum TeamViewServiceStatus { busy, idle }

class TeamViewServiceData {
  List<UserDto> team;
  String? roleName;
  Filter? filter;
  List<UserDto> filteredData;
  TeamViewServiceStatus status;

  TeamViewServiceData({
    required this.team,
    this.roleName,
    this.filteredData = const [],
    this.status = TeamViewServiceStatus.idle,
    this.filter,
  });
}

abstract class Filter {
  String get type;
  String get value;
  Future<List<UserDto>> filter();
}

class TeamByRoleFilter implements Filter {
  RestService restService;
  late String role;

  TeamByRoleFilter(this.restService);

  @override
  Future<List<UserDto>> filter() async {
    var data = await restService.fetchAllUsersByRole(role);
    return data ?? [];
  }

  @override
  String get type => "by_role";

  @override
  String get value => role;
}

class FilterBuilder {
  RestService restService;
  late String role;

  FilterBuilder(this.restService);

  Filter get byRoleFilter => TeamByRoleFilter(restService)..role = role;
}

class TeamViewService extends ValueNotifier<TeamViewServiceData> {
  RestService restService;
  FilterBuilder filterBuilder;
  TeamViewService(this.restService)
      : filterBuilder = FilterBuilder(restService),
        super(TeamViewServiceData(team: []));

  Future<TeamViewService> fetchTeam() async {
    value.status = TeamViewServiceStatus.busy;
    notifyListeners();
    value.team = await restService.fetchAllUsers() ?? [];
    value.status = TeamViewServiceStatus.idle;
    notifyListeners();
    return this;
  }

  Future<TeamViewService> fetchTeamWithFilters(Filter filter) async {
    value.status = TeamViewServiceStatus.busy;
    notifyListeners();
    value.team = await filter.filter();
    value.status = TeamViewServiceStatus.idle;
    notifyListeners();
    return this;
  }
}

class RoleDto {
  final String name;
  final String displayName;

  RoleDto({
    required this.name,
    required this.displayName,
  });
}

final List<RoleDto> roles = [
  RoleDto(name: 'uma_authorization', displayName: 'CEO'),
  RoleDto(name: 'uma_authorization', displayName: 'CTO'),
  RoleDto(name: 'super_admin', displayName: 'Associate Technical Lead'),
  RoleDto(name: 'offline_access', displayName: 'Senior Quality Assurance Engineer'),
  RoleDto(name: 'project_manager', displayName: 'Marketing Specialist'),
  RoleDto(name: 'uma_authorization', displayName: 'Chief Architect'),
  RoleDto(name: 'developer', displayName: 'Senior Software Engineer'),
  RoleDto(name: 'developer', displayName: 'Technical Lead'),
  RoleDto(name: 'developer', displayName: 'Associate Software Engineer'),
  RoleDto(name: 'hr_manager', displayName: 'HR Executive Legal and Compliance'),
  RoleDto(name: 'super_admin', displayName: 'Senior Project Manager'),
  RoleDto(name: 'hr_manager', displayName: 'Associate Manager People Development and Administration'),
  RoleDto(name: 'developer', displayName: 'Associate DevOps Engineer'),
  RoleDto(name: 'uma_authorization', displayName: 'Interns'),
];

class DepartmentDto {
  final String name;
  final String displayName;

  DepartmentDto({
    required this.name,
    required this.displayName,
  });
}

final List<DepartmentDto> departments = [
  DepartmentDto(name: 'Engineering', displayName: 'Engineering'),
  DepartmentDto(name: 'HR_&_Operations', displayName: 'HR & Operations'),
  DepartmentDto(name: 'Operations', displayName: 'Operations'),
  DepartmentDto(name: 'Sales_&_Marketing', displayName: 'Sales & Marketing'),
];
