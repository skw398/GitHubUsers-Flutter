// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $usersListRoute,
    ];

RouteBase get $usersListRoute => GoRouteData.$route(
      path: '/',
      factory: $UsersListRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'user',
          factory: $UserDetailRouteExtension._fromState,
        ),
      ],
    );

extension $UsersListRouteExtension on UsersListRoute {
  static UsersListRoute _fromState(GoRouterState state) =>
      const UsersListRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserDetailRouteExtension on UserDetailRoute {
  static UserDetailRoute _fromState(GoRouterState state) => UserDetailRoute(
        $extra: state.extra as User,
      );

  String get location => GoRouteData.$location(
        '/user',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
