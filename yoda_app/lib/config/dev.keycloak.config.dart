import '../openid.dart';

class OpenIdServiceConfigDev implements OpenIdServiceConfig {
  @override
  final clientId = 'yoda-mobile-dev';

  @override
  final clientSecret = '3vBN3xfdGmYb9fXof7MsDLRodMjTvqY4';

  @override
  final redirectUrl = 'com.techventuras.yoda:/oauthredirect';

  @override
  final postLogoutRedirectUrl = 'com.techventuras.yoda:/oauthredirect';

  @override
  final discoveryUrl =
      'https://keycloak.techventuras.com/auth/realms/yoda-development/.well-known/openid-configuration';
}
