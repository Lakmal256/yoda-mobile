import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoda_app/feather.dart';
import 'package:yoda_app/services/services.dart';

import '../locator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    Key? key,
    this.autoAuth = true,
    required this.onAuth,
  }) : super(key: key);

  final bool autoAuth;
  final void Function(BuildContext) onAuth;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future? authAction;

  handleAuth() async {
    await locate<AuthViewService>().requestToken();
    if (!mounted) return;
    return widget.onAuth(context);
  }

  @override
  void initState() {
    if (widget.autoAuth) authAction = handleAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: authAction != null
            ? FutureBuilder(
                future: authAction,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return AppError(
                      handleRetry: () => setState(() {
                        authAction = handleAuth();
                      }),
                    );
                  }

                  return const SizedBox();
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => setState(() {
                      authAction = handleAuth();
                    }),
                    child: const Text("Sign in with Keycloak"),
                  ),
                ],
              ),
      ),
    );
  }
}

class AppError extends StatelessWidget {
  const AppError({Key? key, required this.handleRetry}) : super(key: key);

  final Function() handleRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign-in process stopped unexpectedly"),
            TextButton(
              onPressed: handleRetry,
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}
