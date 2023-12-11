import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../entity/user.dart';
import '../provider/github_users_notifier_provider.dart';
import '../provider/scroll_controller_provider.dart';

class GitHubUsersListPage extends ConsumerWidget {
  const GitHubUsersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gitHubUsers = ref.watch(gitHubUsersNotifierProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('GitHub Users')),
        body: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(gitHubUsersNotifierProvider.notifier)
                  .fetchUsers(startId: 0);
            },
            child: gitHubUsers.when(
                skipError: true,
                data: (data) {
                  final shouldShowErrorDialog = gitHubUsers.asError != null
                      && ModalRoute.of(context)!.isCurrent
                      && !gitHubUsers.isLoading;
                  if (shouldShowErrorDialog) _showErrorDialog(context);

                  final isLoadingMore = gitHubUsers.isLoading && gitHubUsers.requireValue.isNotEmpty;
                  return ListView.separated(
                      controller: ref.watch(scrollControllerProvider),
                      separatorBuilder: (_, index) => const Divider(height: 0.5),
                      itemCount: data.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == data.length) {
                          return loadingView;
                        } else {
                          final user = data[index];
                          return userListTile(
                            user: user,
                            onTapHandler: () => context.push('/user', extra: user),
                          );
                        }
                      }
                  );
                },
                loading: () {
                  return loadingView;
                },
                error: (e, s) {
                  return errorView(onReloadButtonPressedHandler: () async {
                    await ref
                        .read(gitHubUsersNotifierProvider.notifier)
                        .fetchUsers(startId: 0);
                  });
                }
            )
        )
    );
  }

  Widget userListTile({required User user, required VoidCallback onTapHandler}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: ExtendedNetworkImageProvider(
          user.avatarUrl.toString(),
        ),
      ),
      title: Text(user.name),
      subtitle: Text(user.htmlUrl.toString()),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTapHandler,
    );
  }

  final Widget loadingView = const Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Text('Loading...'),
    ),
  );

  Widget errorView({required VoidCallback onReloadButtonPressedHandler}) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('データの取得に失敗しました'),
            OutlinedButton(
              onPressed: onReloadButtonPressedHandler,
              child: const Text('再読み込み'),
            )
          ],
        ));
  }

  void _showErrorDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('エラー'),
          content: const Text('データの取得に失敗しました'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }
}
