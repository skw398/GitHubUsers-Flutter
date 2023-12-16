import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../view/github_users_list_page.dart';
import '../../view/user_detail_page.dart';
import '../../entity/user.dart';

part 'router.g.dart';

@TypedGoRoute<UsersListRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<UserDetailRoute>(
      path: 'user',
    )
  ],
)

class UsersListRoute extends GoRouteData {
  const UsersListRoute();

  @override
  Widget build(context, state) => const GitHubUsersListPage();
}

class UserDetailRoute extends GoRouteData {
  const UserDetailRoute({required this.$extra});

  final User $extra;

  @override
  Widget build(context, state) {
    return UserDetailPage(user: $extra);
  }
}