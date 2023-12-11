import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/entity/user.dart';
import 'package:github_users/provider/github_users_notifier_provider.dart';
import 'package:github_users/repository/github_users_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'github_users_notifier_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GitHubUsersRepository>()])

void main() {
  group('GitHubUsersNotifier Test', () {
    final mockRepo = MockGitHubUsersRepository();
    final container = ProviderContainer(overrides: [
      gitHubUsersNotifierProvider.overrideWith(() => GitHubUsersNotifier(mockRepo)),
    ]);
    final notifier = container.read(gitHubUsersNotifierProvider.notifier);

    final users = List.generate(20, (i) => User(
      id: i,
      name: "skw398",
      htmlUrl: Uri.parse("https://github.com/skw398"),
      avatarUrl: Uri.parse("https://avatars.githubusercontent.com/u/114917347?v=4"),
    ));

    test('Success', () async {
      when(mockRepo.fetchUsers(userCount: 20, startId: 0)).thenAnswer((_) async => users);

      await notifier.fetchUsers(startId: 0);
      final state = container.read(gitHubUsersNotifierProvider);

      expect(state.value, equals(users));
    });

    test('Failure', () async {
      when(mockRepo.fetchUsers(userCount: 20, startId: 0)).thenThrow(Exception('エラー'));

      await notifier.fetchUsers(startId: 0);
      final state = container.read(gitHubUsersNotifierProvider);

      expect(state, isA<AsyncError>());
    });
  });
}