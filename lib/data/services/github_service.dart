import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/project_models.dart';

class GithubService {
  Future<Map<String, GithubProjectSnapshot>> fetchUserRepositories(String username) async {
    final uri = Uri.parse('https://api.github.com/users/$username/repos?per_page=100&sort=updated');
    final response = await http.get(uri, headers: const {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    });

    if (response.statusCode != 200) {
      throw Exception('GitHub API request failed: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) {
      throw Exception('Unexpected GitHub payload');
    }

    final repositories = <String, GithubProjectSnapshot>{};
    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final name = item['name'] as String?;
      final htmlUrl = item['html_url'] as String?;
      if (name == null || htmlUrl == null) {
        continue;
      }

      repositories[name] = GithubProjectSnapshot(
        name: name,
        description: item['description'] as String?,
        url: htmlUrl,
        updatedAt: DateTime.tryParse(item['updated_at'] as String? ?? ''),
        stars: item['stargazers_count'] as int? ?? 0,
        language: item['language'] as String?,
        homepage: item['homepage'] as String?,
      );
    }

    return repositories;
  }
}
