import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_image/extended_image.dart';

import 'github_users_repository.dart';
import 'user.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) {
        final user = state.extra as User;
        return UserDetailPage(user: user);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GitHubUsersRepository repo = GitHubUsersRepository(dio: Dio());

  List<User> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _fetchUsers();

    _scrollController.addListener(() {
      final reachBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent;
      if (!isLoading && reachBottom) { _fetchUsersMore(); }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("GitHub Users"),
        ),
        body: RefreshIndicator(
          onRefresh: () async { if (!isLoading) { _fetchUsers(); } },
          child: ListView.separated(
            controller: _scrollController,
            separatorBuilder: (context, index) => const Divider(height: 0.5),
            itemCount: users.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == users.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('Loading...'),
                  ),
                );
              } else {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: ExtendedNetworkImageProvider(
                        user.avatarUrl.toString()
                    ),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.htmlUrl.toString()),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => context.push('/user', extra: user),
                );
              }
            },
          ),
        )
    );
  }

  void _fetchUsers() async {
    try {
      setState(() {
        users = [];
        isLoading = true;
      });
      final fetchedUsers = await repo.fetchUsers(userCount: 20, startId: 0);
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('データの取得に失敗しました');
    }
  }

  void _fetchUsersMore() async {
    try {
      setState(() => isLoading = true);
      final fetchedUsers = await repo.fetchUsers(userCount: 20, startId: users.last.id);
      setState(() {
        users += fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('データの取得に失敗しました');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              setState(() => isLoading = false);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: user.htmlUrl),
      ),
    );
  }
}