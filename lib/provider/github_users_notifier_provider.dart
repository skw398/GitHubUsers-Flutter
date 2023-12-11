import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../entity/user.dart';
import '../repository/github_users_repository.dart';

final gitHubUsersNotifierProvider = AsyncNotifierProvider<GitHubUsersNotifier, List<User>>(() {
  return GitHubUsersNotifier(GitHubUsersRepository());
});

class GitHubUsersNotifier extends AsyncNotifier<List<User>> {
  GitHubUsersNotifier(this.repo);

  final GitHubUsersRepository repo;

  @override
  Future<List<User>> build() async {
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
      print(e.toString());
    }
  }
}