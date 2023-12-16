import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_users/entity/user.dart';
import 'package:github_users/controller/github_users_controller.dart';
import 'package:github_users/repository/github_users_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'github_users_notifier_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GitHubUsersRepository>()])

void main() {
  final mockRepo = MockGitHubUsersRepository();

  Future<ProviderContainer> makeContainer(MockGitHubUsersRepository repo) async {
    final container = ProviderContainer(
      overrides: [
        gitHubUsersControllerProvider.overrideWith(() => GitHubUsersController(repo)),
      ],
    );
    await container.read(gitHubUsersControllerProvider.future);
    addTearDown(container.dispose);
    return container;
  }

  test('Success', () async {
    final container = await makeContainer(mockRepo);
    final notifier = container.read(gitHubUsersControllerProvider.notifier);

    final users = List.generate(20, (i) => User(
      id: i,
      name: "skw398",
      htmlUrl: Uri.parse("https://github.com/skw398"),
      avatarUrl: Uri.parse("https://avatars.githubusercontent.com/u/114917347?v=4"),
    ));

    when(mockRepo.fetchUsers(userCount: 20, startId: 0)).thenAnswer((_) async => users);

    await notifier.fetchUsers(startId: 0);
    final state = container.read(gitHubUsersControllerProvider);

    expect(state.value, equals(users));
  });

  test('Failure', () async {
    final container = await makeContainer(mockRepo);
    final notifier = container.read(gitHubUsersControllerProvider.notifier);

    when(mockRepo.fetchUsers(userCount: 20, startId: 0)).thenThrow(Exception('エラー'));

    await notifier.fetchUsers(startId: 0);
    final state = container.read(gitHubUsersControllerProvider);

    expect(state, isA<AsyncError>());
  });
}