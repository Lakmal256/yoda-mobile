import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoda_app/locator.dart';
import 'package:yoda_app/services/services.dart';
import './pages/pages.dart';

GoRouter router = GoRouter(
  errorPageBuilder: (context, state) => MaterialPage(
    child: ErrorPage(routerState: state),
  ),
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      redirect: (context, state) {
        if (locate<AuthViewService>().tokenProvider.hasSession) {
          return "/home";
        }
        return "/auth";
      },
    ),
    GoRoute(
      path: "/auth",
      builder: (context, state) => AuthPage(
        /// By default AuthPage tries to authenticate without pressing eny button
        /// pass [autoAuth] as extra to override
        /// ex: context.go("/auth", extra: {"autoAuth": false});
        autoAuth: (state.extra as Map?)?["autoAuth"] ?? true,
        onAuth: (context) => context.go("/"),
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => MainPage(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const Home();
          },
        ),
        GoRoute(
          path: '/timeEntry',
          builder: (BuildContext context, GoRouterState state) {
            return const TimeTracker();
          },
        ),
        GoRoute(
          path: '/leaveTracker',
          builder: (BuildContext context, GoRouterState state) {
            return const Expanded(
              child: Center(
                child: Text('leaveTracker'),
              ),
            );
          },
        ),
        GoRoute(
          path: '/calendar',
          builder: (BuildContext context, GoRouterState state) {
            return const Calendar();
          },
        ),
        GoRoute(
          path: '/notifications',
          builder: (BuildContext context, GoRouterState state) {
            return const PlaceholderPage(
              child: Text('Notifications'),
            );
          },
        ),
        GoRoute(
          path: '/menu',
          builder: (BuildContext context, GoRouterState state) {
            return const PlaceholderPage(
              child: Text('Menu'),
            );
          },
        ),
        GoRoute(
          path: '/meetTheTeam',
          builder: (BuildContext context, GoRouterState state) {
            return const MeetTheTeam();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const Profile();
          },
        ),
      ],
    )
  ],
);

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.routerState}) : super(key: key);

  final GoRouterState routerState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Page Not Found",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 10),
            Text(
              routerState.error.toString(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: OutlinedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Go Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(child: child),
      ),
    );
  }
}
