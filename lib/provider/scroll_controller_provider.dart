import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'github_users_notifier_provider.dart';

final scrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  final gitHubUsers = ref.watch(gitHubUsersNotifierProvider);

  controller.addListener(() {
    final reachBottom = controller.position.pixels >= controller.position.maxScrollExtent;
    if (!gitHubUsers.isLoading && reachBottom) {
      ref.read(gitHubUsersNotifierProvider.notifier).fetchUsers(startId: gitHubUsers.valueOrNull?.last.id ?? 0);
    }
  });

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});