import 'package:flutter/material.dart';
import 'package:yoda_app/router.dart';
import 'widgets/popup.dart';

import 'services/auth.dart';
import 'services/rest.dart';
import 'theme/provider.dart';

import 'locator.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    locate<RestService>().setErrorHandler(
      RestErrorHandlerWithPopups(locate<PopupController>()),
    );
    return BuildWithTheme(
      builder: (context, theme) {
        return MaterialApp.router(
          theme: theme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) => Material(
            child: Stack(
              fit: StackFit.expand,
              children: [
                child ?? const SizedBox.expand(),
                Popups(controller: locate<PopupController>()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BuildWithTheme extends StatelessWidget {
  final Function(BuildContext, ThemeData) builder;
  const BuildWithTheme({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locate<AppTheme>(),
      builder: (context, value, _) => builder(context, value),
    );
  }
}

class RestErrorHandlerWithPopups extends RestErrorHandler {
  PopupController controller;

  RestErrorHandlerWithPopups(this.controller);

  _popup(String message) {
    controller.addItemFor(
      AlertCard(
        message: message,
        onDismiss: (me) => controller.removeItem(me),
      ),
      const Duration(seconds: 5),
    );
  }

  @override
  handleAuthError() {
    _popup("Auth Error");
  }

  @override
  handleUnknownError() {
    _popup("Something Went Wrong");
  }

  @override
  handleClientError(String message, Uri? uri) {
    _popup(message);
  }

  @override
  handleHttpError(String message, Uri? uri) {
    _popup(message);
  }
}
