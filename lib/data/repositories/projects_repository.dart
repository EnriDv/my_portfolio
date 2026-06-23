import 'package:flutter/material.dart';

import '../content/app_content.dart';
import '../models/project_models.dart';
import '../services/github_service.dart';

class ProjectsRepository {
  ProjectsRepository({
    required GithubService githubService,
  }) : _githubService = githubService;

  final GithubService _githubService;

  List<ProjectMeta> get curatedProjects => _projects;

  Future<List<ProjectViewModel>> loadFeaturedProjects() async {
    final snapshots = await _safeLoadSnapshots();
    final featured = _projects.where((project) => project.featured).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return featured
        .map((project) => ProjectViewModel(
              meta: project,
              github: snapshots[project.repoName],
            ))
        .toList();
  }

  Future<ProjectViewModel?> loadProjectBySlug(String slug) async {
    final project = _projects.where((candidate) => candidate.slug == slug).firstOrNull;
    if (project == null) {
      return null;
    }

    final snapshots = await _safeLoadSnapshots();
    return ProjectViewModel(
      meta: project,
      github: snapshots[project.repoName],
    );
  }

  Future<Map<String, GithubProjectSnapshot>> _safeLoadSnapshots() async {
    try {
      return await _githubService.fetchUserRepositories(profileData.githubUsername);
    } catch (_) {
      return <String, GithubProjectSnapshot>{};
    }
  }
}

const _projects = <ProjectMeta>[
  ProjectMeta(
    slug: 'habitu',
    repoName: 'habitu_ui',
    title: LocalizedText(
      es: 'Habitu',
      en: 'Habitu',
    ),
    summary: LocalizedText(
      es: 'App móvil en Flutter para el seguimiento de hábitos, respaldada por una API REST en C#.',
      en: 'Flutter mobile app for habit tracking and routine management, backed by a C# REST API.',
    ),
    challenge: LocalizedText(
      es: 'Diseñar una experiencia fluida de registro y seguimiento de hábitos diarios con datos persistentes.',
      en: 'Design a smooth experience for daily habit logging and tracking with persistent data.',
    ),
    solution: LocalizedText(
      es: 'Arquitectura Flutter con separación clara de capas y backend .NET para lógica de negocio y persistencia.',
      en: 'Flutter architecture with clear layer separation and a .NET backend for business logic and persistence.',
    ),
    outcome: LocalizedText(
      es: 'Aplicación funcional con UI limpia, navegación fluida y API propia escalable.',
      en: 'Functional app with a clean UI, smooth navigation, and a scalable custom API.',
    ),
    stack: ['Flutter', 'Dart', 'C#', '.NET'],
    order: 1,
    primaryColor: Color(0xFF181818),
    secondaryColor: Color(0xFF2D2D2D),
    featured: true,
  ),
  ProjectMeta(
    slug: 'dims',
    repoName: 'DIMS-frontend',
    title: LocalizedText(
      es: 'DIMS',
      en: 'DIMS',
    ),
    summary: LocalizedText(
      es: 'Sistema web de gestión con frontend en TypeScript y backend en C#, aplicando arquitectura limpia.',
      en: 'Web management system with a TypeScript frontend and C# backend, applying clean architecture.',
    ),
    challenge: LocalizedText(
      es: 'Construir un sistema de gestión completo con interfaz dinámica y lógica de negocio bien separada.',
      en: 'Build a complete management system with a dynamic interface and well-separated business logic.',
    ),
    solution: LocalizedText(
      es: 'Frontend TypeScript desacoplado del backend C# REST, siguiendo principios SOLID y patrones de diseño.',
      en: 'TypeScript frontend decoupled from the C# REST backend, following SOLID principles and design patterns.',
    ),
    outcome: LocalizedText(
      es: 'Sistema funcional con capas bien definidas y base sólida para escalar con nuevos módulos.',
      en: 'Functional system with well-defined layers and a solid base to scale with new modules.',
    ),
    stack: ['TypeScript', 'C#', '.NET', 'REST API'],
    order: 2,
    primaryColor: Color(0xFF181818),
    secondaryColor: Color(0xFF2D2D2D),
    featured: true,
  ),
  ProjectMeta(
    slug: 'hipermaxi',
    repoName: 'Hipermaxi-Frontend',
    title: LocalizedText(
      es: 'Hipermaxi',
      en: 'Hipermaxi',
    ),
    summary: LocalizedText(
      es: 'Plataforma web para cadena retail con frontend en TypeScript y backend en Python.',
      en: 'Web platform for a retail chain with a TypeScript frontend and Python backend.',
    ),
    challenge: LocalizedText(
      es: 'Modelar la experiencia de usuario de una plataforma retail con catálogo y flujo de pedidos.',
      en: 'Model the user experience of a retail platform with a product catalog and order flow.',
    ),
    solution: LocalizedText(
      es: 'Frontend TypeScript con backend Python exponiendo datos a través de una API REST bien definida.',
      en: 'TypeScript frontend with a Python backend exposing data through a well-defined REST API.',
    ),
    outcome: LocalizedText(
      es: 'Plataforma funcional que conecta frontend moderno con backend Python en un stack completo.',
      en: 'Functional platform connecting a modern frontend with a Python backend in a full stack.',
    ),
    stack: ['TypeScript', 'Python', 'REST API'],
    order: 3,
    primaryColor: Color(0xFF181818),
    secondaryColor: Color(0xFF2D2D2D),
    featured: true,
  ),
  ProjectMeta(
    slug: 'portfolio-flutter-web',
    repoName: 'my_portfolio',
    title: LocalizedText(
      es: 'Portafolio Flutter Web',
      en: 'Flutter Web Portfolio',
    ),
    summary: LocalizedText(
      es: 'Portafolio bilingüe con CV dinámico y detalle por proyecto, construido en Flutter Web.',
      en: 'Bilingual portfolio with dynamic resume and project detail pages, built in Flutter Web.',
    ),
    challenge: LocalizedText(
      es: 'Llevar el portafolio a un stack más mantenible sin perder personalidad visual.',
      en: 'Move the portfolio to a more maintainable stack without losing visual personality.',
    ),
    solution: LocalizedText(
      es: 'Organicé la app por features con datos curados y contenido reutilizable para web y PDF.',
      en: 'I organized the app around features with curated data and reusable content for web and PDF.',
    ),
    outcome: LocalizedText(
      es: 'Base lista para iterar diseño, contenido y nuevas rutas sin rehacer la app.',
      en: 'Foundation ready to evolve in design, content, and new routes without rebuilding.',
    ),
    stack: ['Flutter', 'Dart', 'GitHub API'],
    order: 4,
    primaryColor: Color(0xFF181818),
    secondaryColor: Color(0xFF2D2D2D),
    featured: true,
  ),
];
