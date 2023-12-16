import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/user.dart';
import '../repository/github_users_repository.dart';

part 'github_users_controller.g.dart';

@riverpod
class GitHubUsersController extends _$GitHubUsersController {
  GitHubUsersController([GitHubUsersRepository? repo])
      : repo = repo ?? GitHubUsersRepository();

  final GitHubUsersRepository repo;

  @override
  FutureOr<List<User>> build() async {
    return fetchUsers(startId: 0).then((_) => state.value ?? []);
  }

  Future<void> fetchUsers({required int startId}) async {
    final isInitialFetch = startId == 0;
    state = isInitialFetch
        ? const AsyncValue.loading()
        : const AsyncLoading<List<User>>().copyWithPrevious(state);

    try {
      final fetchedUsers = await repo.fetchUsers(userCount: 20, startId: startId);
      final previousUsers = state.asData?.value ?? [];
      final users = isInitialFetch ? fetchedUsers : [...previousUsers, ...fetchedUsers];

      state = AsyncValue.data(users);
    } catch (e, s) {
      state = AsyncError<List<User>>(e, s).copyWithPrevious(state);
      debugPrint(e.toString());
    }
  }
}