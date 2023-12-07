import 'package:dio/dio.dart';
import 'user.dart';

class GitHubUsersRepository {
  final Dio dio;

  GitHubUsersRepository({required this.dio});

  Future<List<User>> fetchUsers({required int userCount, required int startId}) async {
    final queryParameters = {
      "since": startId,
      "per_page": userCount,
    };

    await Future.delayed(const Duration(milliseconds: 500)); // デバッグ

    final response = await dio.get(
      'https://api.github.com/users',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((data) => User.fromJson(data))
          .toList();
    } else {
      throw Exception('エラー');
    }
  }
}