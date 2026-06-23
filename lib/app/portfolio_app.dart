import 'package:flutter/material.dart';

import '../data/content/app_content.dart';
import '../data/repositories/cv_repository.dart';
import '../data/repositories/projects_repository.dart';
import '../data/services/github_service.dart';
import '../features/cv/cv_page.dart';
import '../features/home/home_page.dart';
import '../features/projects/project_detail_page.dart';
import '../theme/app_theme.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  AppLocale _locale = AppLocale.es;

  late final GithubService _githubService = GithubService();
  late final ProjectsRepository _projectsRepository = ProjectsRepository(
    githubService: _githubService,
  );
  late final CvRepository _cvRepository = CvRepository();

  void _toggleLocale() {
    setState(() {
      _locale = _locale == AppLocale.es ? AppLocale.en : AppLocale.es;
    });
  }

  Route<dynamic> _buildRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final path = uri.path.isEmpty ? '/' : uri.path;

    if (path == '/') {
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/'),
        builder: (_) => HomePage(
          locale: _locale,
          onToggleLocale: _toggleLocale,
          projectsRepository: _projectsRepository,
          cvRepository: _cvRepository,
        ),
      );
    }

    if (path == '/cv') {
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/cv'),
        builder: (_) => CvPage(
          locale: _locale,
          onToggleLocale: _toggleLocale,
          cvRepository: _cvRepository,
        ),
      );
    }

    if (pathSegmentsMatch(uri, 'projects')) {
      final slug = uri.pathSegments[1];
      return MaterialPageRoute<void>(
        settings: RouteSettings(name: '/projects/$slug'),
        builder: (_) => ProjectDetailPage(
          locale: _locale,
          onToggleLocale: _toggleLocale,
          projectSlug: slug,
          projectsRepository: _projectsRepository,
        ),
      );
    }

    return MaterialPageRoute<void>(
      builder: (_) => HomePage(
        locale: _locale,
        onToggleLocale: _toggleLocale,
        projectsRepository: _projectsRepository,
        cvRepository: _cvRepository,
      ),
    );
  }

  bool pathSegmentsMatch(Uri uri, String prefix) {
    return uri.pathSegments.length == 2 && uri.pathSegments.first == prefix;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enri DV Portfolio',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: _buildRoute,
    );
  }
}
