import 'package:flutter/material.dart';

import '../content/app_content.dart';

class ProjectMeta {
  const ProjectMeta({
    required this.slug,
    required this.repoName,
    required this.title,
    required this.summary,
    required this.challenge,
    required this.solution,
    required this.outcome,
    required this.stack,
    required this.order,
    required this.primaryColor,
    required this.secondaryColor,
    required this.featured,
    this.demoUrl,
  });

  final String slug;
  final String repoName;
  final LocalizedText title;
  final LocalizedText summary;
  final LocalizedText challenge;
  final LocalizedText solution;
  final LocalizedText outcome;
  final List<String> stack;
  final int order;
  final Color primaryColor;
  final Color secondaryColor;
  final bool featured;
  final String? demoUrl;
}

class GithubProjectSnapshot {
  const GithubProjectSnapshot({
    required this.name,
    required this.description,
    required this.url,
    required this.updatedAt,
    required this.stars,
    required this.language,
    required this.homepage,
  });

  final String name;
  final String? description;
  final String url;
  final DateTime? updatedAt;
  final int stars;
  final String? language;
  final String? homepage;
}

class ProjectViewModel {
  const ProjectViewModel({
    required this.meta,
    this.github,
  });

  final ProjectMeta meta;
  final GithubProjectSnapshot? github;

  String title(AppLocale locale) => meta.title.of(locale);
  String summary(AppLocale locale) => meta.summary.of(locale);
  String challenge(AppLocale locale) => meta.challenge.of(locale);
  String solution(AppLocale locale) => meta.solution.of(locale);
  String outcome(AppLocale locale) => meta.outcome.of(locale);

  String get sourceUrl => github?.url ?? 'https://github.com/EnriDv/${meta.repoName}';
  String? get liveUrl => meta.demoUrl ?? github?.homepage;
  bool get hasGithubData => github != null;
}
