import '../openid.dart';

class OpenIdServiceConfigProd implements OpenIdServiceConfig {
  @override
  final clientId = 'yoda-mobile';

  @override
  final clientSecret = 'UbkQA5IijtochoCHhkFQVqh72jvQGZZy';

  @override
  final redirectUrl = 'com.techventuras.yoda:/oauthredirect';

  @override
  final postLogoutRedirectUrl = 'com.techventuras.yoda:/oauthredirect';

  @override
  final discoveryUrl = 'https://keycloak.techventuras.com/auth/realms/techventuras/.well-known/openid-configuration';
}
