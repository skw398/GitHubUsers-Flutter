import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'github_users_controller.dart';

part 'scroll_controller.g.dart';

@riverpod
ScrollController scrollController(ScrollControllerRef ref) {
  final controller = ScrollController();

  controller.addListener(() {
    final reachBottom = controller.position.pixels >= controller.position.maxScrollExtent;
    final gitHubUsers = ref.read(gitHubUsersControllerProvider);
    if (!gitHubUsers.isLoading && reachBottom) {
      ref.read(gitHubUsersControllerProvider.notifier).fetchUsers(startId: gitHubUsers.valueOrNull?.last.id ?? 0);
    }
  });

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
}