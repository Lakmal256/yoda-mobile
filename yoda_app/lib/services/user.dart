import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:yoda_app/services/services.dart';

class UserViewService extends ValueNotifier<UserDto?> {
  RestService restService;
  UserViewService(this.restService) : super(UserDto());

  Future<UserViewService> fetchUser() async {
    value = await restService.fetchCurrentUser();
    notifyListeners();
    return this;
  }

  set user(UserDto user) {
    value = user;
    notifyListeners();
  }

  Future<NetworkImage?> get profileImage async {
    if (value?.profilePicture != null) {
      return NetworkImage(
        Uri.http(
          restService.restConfig.authority,
          "${restService.restConfig.fileDownload}/${value?.profilePicture}",
        ).toString(),
        headers: {"Authorization": "Bearer ${await restService.tokenProvider.getToken()}"},
      );
    }
    return null;
  }
}
