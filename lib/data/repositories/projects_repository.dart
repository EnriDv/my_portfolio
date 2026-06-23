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
    slug: 'portafolio-vanillajs',
    repoName: 'Portafolio',
    title: LocalizedText(
      es: 'Portafolio en Vanilla JS',
      en: 'Vanilla JS Portfolio',
    ),
    summary: LocalizedText(
      es: 'Mi versión anterior: una base rápida para mostrar identidad visual y proyectos.',
      en: 'My previous version: a fast base to showcase visual identity and projects.',
    ),
    challenge: LocalizedText(
      es: 'Quería un sitio personal ligero que me permitiera presentar proyectos de forma directa.',
      en: 'I wanted a lightweight personal site that could present projects in a direct way.',
    ),
    solution: LocalizedText(
      es: 'Diseñé una landing simple, rápida y fácil de desplegar con contenido curado y foco visual.',
      en: 'I designed a simple, fast, easy-to-deploy landing page with curated content and strong visuals.',
    ),
    outcome: LocalizedText(
      es: 'Sirvió como base para evolucionar ahora hacia una experiencia más robusta en Flutter Web.',
      en: 'It worked as a foundation to evolve into a more robust Flutter Web experience.',
    ),
    stack: ['JavaScript', 'HTML', 'CSS'],
    order: 1,
    primaryColor: Color(0xFFE96B53),
    secondaryColor: Color(0xFFF5C3AE),
    featured: true,
  ),
  ProjectMeta(
    slug: 'portfolio-flutter-web',
    repoName: 'my_portfolio',
    title: LocalizedText(
      es: 'Portafolio en Flutter Web',
      en: 'Flutter Web Portfolio',
    ),
    summary: LocalizedText(
      es: 'Una reconstrucción moderna, bilingüe y escalable con CV dinámico y detalle por proyecto.',
      en: 'A modern, bilingual, scalable rebuild with a dynamic resume and project detail pages.',
    ),
    challenge: LocalizedText(
      es: 'Llevar el portafolio a un stack más mantenible sin perder personalidad visual.',
      en: 'Move the portfolio to a more maintainable stack without losing visual personality.',
    ),
    solution: LocalizedText(
      es: 'Organicé la app por features, datos curados y contenido reutilizable para web y PDF.',
      en: 'I organized the app around features, curated data, and reusable content for web and PDF.',
    ),
    outcome: LocalizedText(
      es: 'Ahora la base está lista para iterar diseño, contenido y nuevas rutas sin rehacer la app.',
      en: 'The foundation is now ready to evolve in design, content, and new routes without rebuilding the app.',
    ),
    stack: ['Flutter', 'Dart', 'GitHub API'],
    order: 2,
    primaryColor: Color(0xFF1E7A72),
    secondaryColor: Color(0xFFBDE5DC),
    featured: true,
  ),
  ProjectMeta(
    slug: 'github-powered-showcase',
    repoName: 'Portafolio',
    title: LocalizedText(
      es: 'Showcase conectado a GitHub',
      en: 'GitHub-powered showcase',
    ),
    summary: LocalizedText(
      es: 'Una capa de contenido curado que se enriquece con datos públicos del perfil.',
      en: 'A curated content layer enhanced by public profile data.',
    ),
    challenge: LocalizedText(
      es: 'Evitar que el portfolio dependa por completo de lo que GitHub expone automáticamente.',
      en: 'Avoid making the portfolio depend entirely on whatever GitHub exposes automatically.',
    ),
    solution: LocalizedText(
      es: 'Combino metadata local con información remota para mantener control visual y editorial.',
      en: 'I combine local metadata with remote information to keep editorial and visual control.',
    ),
    outcome: LocalizedText(
      es: 'Los proyectos mantienen contexto, orden y storytelling, incluso si la API falla.',
      en: 'Projects keep context, order, and storytelling even if the API fails.',
    ),
    stack: ['REST API', 'JSON', 'Flutter'],
    order: 3,
    primaryColor: Color(0xFFD6A44D),
    secondaryColor: Color(0xFFF5E5BE),
    featured: true,
  ),
];
