import 'package:flutter/material.dart';

import '../../data/content/app_content.dart';
import '../../data/models/project_models.dart';
import '../../data/repositories/projects_repository.dart';
import '../../shared/services/browser_service.dart';
import '../../shared/widgets/portfolio_scaffold.dart';
import '../../theme/app_theme.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({
    super.key,
    required this.locale,
    required this.onToggleLocale,
    required this.projectSlug,
    required this.projectsRepository,
  });

  final AppLocale locale;
  final VoidCallback onToggleLocale;
  final String projectSlug;
  final ProjectsRepository projectsRepository;

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      locale: locale,
      onToggleLocale: onToggleLocale,
      body: FutureBuilder<ProjectViewModel?>(
        future: projectsRepository.loadProjectBySlug(projectSlug),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final project = snapshot.data;

          if (project == null) {
            final notFoundLabel =
                locale == AppLocale.es ? 'Proyecto no encontrado' : 'Project not found';
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        notFoundLabel,
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pushNamed('/'),
                        child: Text(appStrings.cvBackHome.of(locale)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeaderPreview(project: project),
                            const SizedBox(height: 24),
                            Text(
                              project.title(locale),
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              project.summary(locale),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                FilledButton(
                                  onPressed: () => openExternalUrl(project.sourceUrl),
                                  child: Text(appStrings.ctaSourceCode.of(locale)),
                                ),
                                if (project.liveUrl != null)
                                  OutlinedButton(
                                    onPressed: () => openExternalUrl(project.liveUrl!),
                                    child: Text(appStrings.ctaLiveDemo.of(locale)),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _DetailBlock(
                      title: appStrings.projectChallenge.of(locale),
                      body: project.challenge(locale),
                    ),
                    const SizedBox(height: 18),
                    _DetailBlock(
                      title: appStrings.projectSolution.of(locale),
                      body: project.solution(locale),
                    ),
                    const SizedBox(height: 18),
                    _DetailBlock(
                      title: appStrings.projectImpact.of(locale),
                      body: project.outcome(locale),
                    ),
                    const SizedBox(height: 18),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appStrings.projectStack.of(locale),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: project.meta.stack
                                  .map((item) => Chip(label: Text(item)))
                                  .toList(),
                            ),
                            if (!project.hasGithubData) ...[
                              const SizedBox(height: 16),
                              Text(
                                appStrings.githubUnavailable.of(locale),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ] else ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 18,
                                runSpacing: 10,
                                children: [
                                  Text(
                                    '${project.github!.stars} ${appStrings.githubStars.of(locale)}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  if (project.github!.language != null)
                                    Text(
                                      project.github!.language!,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (project.github!.updatedAt != null)
                                    Text(
                                      '${appStrings.githubUpdated.of(locale)} ${_formatDate(project.github!.updatedAt!)}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _HeaderPreview extends StatelessWidget {
  const _HeaderPreview({required this.project});

  final ProjectViewModel project;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              project.meta.primaryColor,
              project.meta.secondaryColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                width: 220,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              top: 54,
              left: 24,
              child: Container(
                width: 280,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: Container(
                width: 160,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.ink.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
