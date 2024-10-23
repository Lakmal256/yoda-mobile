import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yoda_app/util/storage.dart';

class AuthException implements Exception {
  AuthException() : super();
}

class _AuthDetails {
  String? refreshToken;
  String? accessToken;
  String? idToken;
  DateTime? accessTokenExpirationDateTime;
}

class TokenProvider {
  AuthService service;
  _AuthDetails _authDetails;
  TokenProvider({String? refreshToken, required this.service})
      : _authDetails = _AuthDetails()..refreshToken = refreshToken;

  bool isExpired() {
    return _authDetails.accessTokenExpirationDateTime != null &&
        _authDetails.accessTokenExpirationDateTime!.isBefore(DateTime.now());
  }

  _setAuthDetailsFromTokenResponse(TokenResponse response) {
    _authDetails = _authDetails
      ..accessToken = response.accessToken
      ..refreshToken = response.refreshToken
      ..idToken = response.idToken
      ..accessTokenExpirationDateTime = response.accessTokenExpirationDateTime;
  }

  _refresh() async {
    final response = await service.refresh(refreshToken: _authDetails.refreshToken!);
    if (response != null) {
      _setAuthDetailsFromTokenResponse(response);
      await LocalTokenHandler.saveRefreshToken(response.refreshToken!);
    }
  }

  _tryRefresh() async {
    try {
      if (JwtDecoder.isExpired(_authDetails.refreshToken!)) {
        throw Exception();
      } else {
        await _refresh();
      }
    } on Exception {
      await _authorize();
    }
  }

  _authorize() async {
    final response = await service.authorize();
    if (response != null) {
      _setAuthDetailsFromTokenResponse(response);
      await LocalTokenHandler.saveRefreshToken(response.refreshToken!);
    }
  }

  @Deprecated("For testing purposes only!!")
  expireRefreshToken() async {
    _authDetails.refreshToken = "__null__";
    await LocalTokenHandler.saveRefreshToken("__null__");
  }

  Future<String> getToken() async {
    try {
      if (_authDetails.accessToken == null) {
        if (_authDetails.refreshToken != null) {
          await _tryRefresh();
        } else {
          await _authorize();
        }
      }

      if (isExpired()) {
        await _tryRefresh();
      }

      return _authDetails.accessToken!;
    } on Exception {
      throw AuthException();
    }
  }

  Future<String?> endSession() async {
    if (_authDetails.idToken != null) {
      final result = await service.endSession(idToken: _authDetails.idToken!);
      if (result != null) {
        _authDetails = _AuthDetails();
        await LocalTokenHandler.eraseTokens();
        return result.state;
      }
    }

    return null;
  }

  bool get hasSession => _authDetails.accessToken != null && !isExpired();
}

class LocalTokenHandler {
  static Future<String?> readRefreshToken() async {
    Map? tokens = await Storage.instance.read("tokens");
    return tokens?['refresh_token'];
  }

  static Future eraseTokens() async {
    await Storage.instance.delete("tokens");
  }

  static Future saveRefreshToken(String token) async {
    await Storage.instance.write("tokens", {'refresh_token': token});
  }
}

class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final String clientId;
  final String redirectUrl;
  final String discoveryUrl;
  final String clientSecret;
  final String postLogoutRedirectUrl;
  final List<String> _scopes = [
    "openid",
    "phone",
    "profile",
    "email",
    "microprofile-jwt",
    "roles",
    "web-origins",
    "address"
  ];

  AuthService(
      {required this.clientId,
      required this.redirectUrl,
      required this.discoveryUrl,
      required this.clientSecret,
      required this.postLogoutRedirectUrl});

  Future<AuthorizationTokenResponse?> authorize({bool preferEphemeralSession = false}) {
    return _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        clientId,
        redirectUrl,
        discoveryUrl: discoveryUrl,
        clientSecret: clientSecret,
        scopes: _scopes,
        preferEphemeralSession: preferEphemeralSession,
      ),
    );
  }

  Future<TokenResponse?> refresh({required String refreshToken}) {
    return _appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        refreshToken: refreshToken,
        discoveryUrl: discoveryUrl,
        clientSecret: clientSecret,
        scopes: _scopes,
      ),
    );
  }

  /// Logout Flow - AlertView saying SIGN IN
  /// https://github.com/openid/AppAuth-iOS/issues/643
  Future<EndSessionResponse?> endSession({required String idToken, bool preferEphemeralSession = false}) {
    return _appAuth.endSession(
      EndSessionRequest(
        idTokenHint: idToken,
        discoveryUrl: discoveryUrl,
        postLogoutRedirectUrl: postLogoutRedirectUrl,
        preferEphemeralSession: preferEphemeralSession,
      ),
    );
  }
}

class AuthViewService extends ValueNotifier<_AuthDetails> {
  TokenProvider tokenProvider;

  AuthViewService(this.tokenProvider) : super(tokenProvider._authDetails);

  Future<String?> requestToken() async {
    await tokenProvider.getToken();
    value = tokenProvider._authDetails;
    notifyListeners();

    return value.accessToken;
  }

  Future endSession() async {
    await tokenProvider.endSession();
    value = tokenProvider._authDetails;
    notifyListeners();
  }
}
