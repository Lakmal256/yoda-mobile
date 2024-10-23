import 'package:get_it/get_it.dart';
import 'package:yoda_app/config/prod.api.config.dart';
import 'package:yoda_app/config/prod.keycloak.config.dart';
import 'package:yoda_app/rest.dart';

import 'package:yoda_app/theme/theme.dart';
import 'package:yoda_app/theme/provider.dart';
import 'package:yoda_app/widgets/popup.dart';

import 'config/dev.api.config.dart';
import 'config/dev.keycloak.config.dart';
import 'openid.dart';
import 'services/services.dart';

GetIt getIt = GetIt.instance;

setupServiceLocator() async {
  String? refreshToken = await LocalTokenHandler.readRefreshToken();

  OpenIdServiceConfig openIdServiceConfig;
  RestConfig restConfig;

  const env = "__DEV__";

  switch (env) {
    case "__PROD__":
      openIdServiceConfig = OpenIdServiceConfigProd();
      restConfig = RestConfigProd();
      break;
    default:
      openIdServiceConfig = OpenIdServiceConfigDev();
      restConfig = RestConfigDev();
      break;
  }

  RestService restService = RestService(
    restConfig: restConfig,
    tokenProvider: TokenProvider(
      refreshToken: refreshToken,
      service: AuthService(
        clientId: openIdServiceConfig.clientId,
        redirectUrl: openIdServiceConfig.redirectUrl,
        discoveryUrl: openIdServiceConfig.discoveryUrl,
        clientSecret: openIdServiceConfig.clientSecret,
        postLogoutRedirectUrl: openIdServiceConfig.postLogoutRedirectUrl,
      ),
    ),
  );

  getIt.registerSingleton(AppTheme(lightTheme));
  getIt.registerSingleton(PopupController());
  getIt.registerSingleton(AppSettings());

  getIt.registerSingleton(restService);

  getIt.registerSingleton(AuthViewService(restService.tokenProvider));
  getIt.registerSingleton(UserViewService(restService));
  getIt.registerSingleton(ProjectViewService(restService));
  getIt.registerSingleton(EpicViewService(restService));
  getIt.registerSingleton(HolidayViewService(restService));
  getIt.registerSingleton(TeamViewService(restService));
}

T locate<T extends Object>() => GetIt.instance<T>();