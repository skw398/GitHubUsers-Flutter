// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_users/View/main.dart';
import 'package:github_users/entity/user.dart';
import 'package:github_users/controller/github_users_controller.dart';
import 'package:mockito/mockito.dart';
import 'github_users_notifier_test.mocks.dart';

void main() {
  final mockRepo = MockGitHubUsersRepository();

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gitHubUsersControllerProvider.overrideWith(() => GitHubUsersController(mockRepo)),
        ],
        child: MyApp(),
      ),
    );
  }

  group('GitHubUsersPage Test', () {
    setUp(() {
      HttpOverrides.global = null;
    });

    testWidgets('Success', (WidgetTester tester) async {
      final users = List.generate(20, (i) => User(
        id: i,
        name: "skw398",
        htmlUrl: Uri.parse("https://github.com/skw398"),
        avatarUrl: Uri.parse("https://avatars.githubusercontent.com/u/114917347?v=4"),
      ));
      when(mockRepo.fetchUsers(userCount: 20, startId: 0)).thenAnswer((_) async => users);

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Failure', (WidgetTester tester) async {
      when(mockRepo.fetchUsers(userCount: 20, startId: 0)).thenThrow(Exception('エラー'));

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(find.text('再読み込み'), findsOneWidget);
    });
  });
}
