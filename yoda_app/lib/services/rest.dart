import 'dart:io';
import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../rest.dart';
import 'services.dart';

class RestErrorHandler {
  handleClientError(String message, Uri? uri) {
    throw UnimplementedError();
  }

  handleHttpError(String message, Uri? uri) {
    throw UnimplementedError();
  }

  handleAuthError() {
    throw UnimplementedError();
  }

  handleUnknownError() {
    throw UnimplementedError();
  }
}

class RestService {
  TokenProvider tokenProvider;
  RestErrorHandler? errorHandler;
  RestConfig restConfig;
  http.Client client = http.Client();

  RestService({
    required this.tokenProvider,
    required this.restConfig,
    this.errorHandler,
  });

  setErrorHandler(RestErrorHandler errorHandler){
    this.errorHandler = errorHandler;
  }

  Future<T?> _requestAsync<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on http.ClientException catch (error) {
      errorHandler?.handleClientError(error.message, error.uri);
    } on HttpException catch (error) {
      errorHandler?.handleHttpError(error.message, error.uri);
    } on AuthException {
      errorHandler?.handleAuthError();
    } on Exception {
      errorHandler?.handleUnknownError();
    }

    return null;
  }

  handleResponse(http.Response response) {
    if (response.statusCode ~/ 100 != 2) {
      throw HttpException(
        "${response.statusCode}: ${response.body}",
        uri: response.request?.url,
      );
    }
  }

  Future<List<EpicDto>?> fetchEpicsByProjectId(int id) {
    return _requestAsync<List<EpicDto>?>(() async {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.http(restConfig.authority, restConfig.epics, {"projectId": "$id"}),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = convert.jsonDecode(response.body);
        return ((jsonBody["data"] ?? []) as List).map((item) => EpicDto.fromJson(item)).toList();
      }

      handleResponse(response);
      return null;
    });
  }

  Future<ProjectDto?> fetchProjectById(int id) {
    return _requestAsync<ProjectDto?>(() async {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.http(restConfig.authority, "${restConfig.projects}/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        return ProjectDto.fromJson(convert.jsonDecode(response.body));
      }

      handleResponse(response);
      return null;
    });
  }

  Future<List<ProjectDto>?> fetchProjects() {
    return _requestAsync<List<ProjectDto>?>(() async {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.http(restConfig.authority, restConfig.projects, {}),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = convert.jsonDecode(response.body);
        return ((jsonBody["data"] ?? []) as List).map((item) => ProjectDto.fromJson(item)).toList();
      }

      handleResponse(response);
      return null;
    });
  }

  Future createTimeEntry({
    required UserDto user,
    required ProjectDto project,
    required EpicDto epic,
    required DateTime date,
    required double minutes,
    required String task,
    required String? description,
    required List<String> files,
  }) async {
    return _requestAsync(() async {
      final token = await tokenProvider.getToken();
      final body = convert.json.encode({
        "user": {"id": user.id},
        "project": {"id": project.id},
        "epic": {"id": epic.id},
        "taskDescription": description,
        "workDate": date.toIso8601String(),
        "taskMinutes": minutes,
        "documentList": files,
        "taskTitle": task,
      });

      final request = http.Request(
          "POST",
          Uri.http(
            restConfig.authority,
            restConfig.timeLogs,
          ))
        ..body = body
        ..headers.addAll(
          {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json",
          },
        );

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        return response.body;
      }

      handleResponse(response);
      return null;
    });
  }

  Future<UserDto?> fetchCurrentUser() {
    return _requestAsync<UserDto?>(() async {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.http(restConfig.authority, restConfig.usersCurrent),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        UserDto userDto = UserDto.fromJson(convert.jsonDecode(response.body));
        // userDto.imageBytes = await downloadFile(userDto.profilePicture);
        return userDto;
      }

      handleResponse(response);
      return null;
    });
  }

  Future<List<UserDto>?> fetchAllUsers() {
    return _requestAsync<List<UserDto>>(() async {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.http(restConfig.authority, restConfig.users),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = convert.jsonDecode(response.body);
        List<UserDto> users = [];
        for (var userJson in jsonBody["data"] ?? []) {
          UserDto userDto = UserDto.fromJson(userJson);
          // userDto.imageBytes = await downloadFile(userDto.profilePicture);
          users.add(userDto);
        }
        return users;
      }

      handleResponse(response);
      return [];
    });
  }


  Future<List<UserDto>?> fetchAllUsersByRole(String roleName) {
    return _requestAsync<List<UserDto>>(() async {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.http(restConfig.authority, "${restConfig.usersByRole}/$roleName"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = convert.jsonDecode(response.body);
        List<UserDto> users = [];
        for (var userJson in jsonBody ?? []) {
          UserDto userDto = UserDto.fromJson(userJson);
          // userDto.imageBytes = await downloadFile(userDto.profilePicture);
          users.add(userDto);
        }
        return users;
      }
      handleResponse(response);
      return [];
    });
  }

  Future downloadFile(String? fileName) {
    return _requestAsync<Uint8List?>(() async {
      final token = await tokenProvider.getToken();
      final response = await client.get(
        Uri.http(restConfig.authority, "${restConfig.fileDownload}/$fileName"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        return response.bodyBytes;
      }

      handleResponse(response);
      return null;
    });
  }

  Future<List<HolidayDto>?> fetchHolidays(DateTime startDate, DateTime endDate) {
    return _requestAsync<List<HolidayDto>?>(() async {
      final token = await tokenProvider.getToken();
      final dFormatter = DateFormat("yyyy-MM-dd");
      final response = await client.get(
        Uri.http(restConfig.authority, restConfig.holidays, {
          "fromDate": dFormatter.format(startDate),
          "toDate": dFormatter.format(endDate),
        }),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == HttpStatus.ok) {
        final jsonBody = convert.jsonDecode(response.body);
        return ((jsonBody["data"] ?? []) as List).map((item) => HolidayDto.fromJson(item)).toList();
      }

      handleResponse(response);
      return null;
    });
  }

  Stream<double> getTestStream() async* {
    for (int i = 0; i < 100; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield i / 100;
    }
  }

  Stream<UploaderStreamedResponse> uploadFileStream(String name, List<int> bytes) async* {
    final token = await tokenProvider.getToken();
    Uri uri = Uri.http(restConfig.authority, restConfig.fileUpload);

    final request = http.MultipartRequest("POST", uri)
      ..files.add(http.MultipartFile.fromBytes("file", bytes, filename: name))
      ..headers.addAll({HttpHeaders.authorizationHeader: "Bearer $token"});

    final streamedResponse = await client.send(request);
    final uResponse = UploaderStreamedResponse(statusCode: streamedResponse.statusCode)
      ..totalByteCount = streamedResponse.contentLength;

    yield uResponse;

    yield* streamedResponse.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(uResponse..bodyBytes.addAll(data));
        },
        handleError: (error, trace, sink) => sink.addError(error, trace),
        handleDone: (sink) => sink.close(),
      ),
    );

    yield uResponse;
  }

  Future<String?> uploadAsync(String name, List<int> bytes) {
    return _requestAsync(() async {
      final token = await tokenProvider.getToken();
      Uri uri = Uri.http(restConfig.authority, restConfig.fileUpload);

      http.MultipartRequest multipartRequest = http.MultipartRequest("POST", uri)
        ..files.add(http.MultipartFile.fromBytes("file", bytes, filename: name))
        ..headers.addAll({"Authorization": "Bearer $token"});

      final response = await http.Response.fromStream(await multipartRequest.send());

      handleResponse(response);

      return response.body;
    });
  }
}

class UploaderStreamedResponse {
  List<int> bodyBytes;
  int? totalByteCount;
  int statusCode;

  UploaderStreamedResponse({required this.statusCode})
      : bodyBytes = List.empty(growable: true),
        totalByteCount = 0;

  double get progress => totalByteCount != null ? bodyBytes.length / totalByteCount! : 0;
  http.Response get response => http.Response.bytes(bodyBytes, statusCode);
}
