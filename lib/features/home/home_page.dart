import 'package:flutter/material.dart';

import '../../data/content/app_content.dart';
import '../../data/models/cv_models.dart';
import '../../data/models/project_models.dart';
import '../../data/repositories/cv_repository.dart';
import '../../data/repositories/projects_repository.dart';
import '../../shared/services/browser_service.dart';
import '../../shared/widgets/portfolio_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.locale,
    required this.onToggleLocale,
    required this.projectsRepository,
    required this.cvRepository,
  });

  final AppLocale locale;
  final VoidCallback onToggleLocale;
  final ProjectsRepository projectsRepository;
  final CvRepository cvRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _projectsKey = GlobalKey();
  final _cvKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) {
      return;
    }

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      locale: widget.locale,
      onToggleLocale: widget.onToggleLocale,
      currentRoute: '/',
      body: FutureBuilder<List<Object>>(
        future: Future.wait<Object>([
          widget.projectsRepository.loadFeaturedProjects(),
          widget.cvRepository.load(widget.locale),
        ]),
        builder: (context, snapshot) {
          final projects = snapshot.hasData
              ? snapshot.data![0] as List<ProjectViewModel>
              : const <ProjectViewModel>[];
          final cv = snapshot.hasData ? snapshot.data![1] as CvDocument : null;

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroSection(
                      locale: widget.locale,
                      onProjectsPressed: () => _scrollTo(_projectsKey),
                      onCvPressed: () => Navigator.of(context).pushNamed('/cv'),
                    ),
                    const SizedBox(height: 36),
                    _AboutSection(locale: widget.locale),
                    const SizedBox(height: 36),
                    KeyedSubtree(
                      key: _projectsKey,
                      child: _ProjectsSection(
                        locale: widget.locale,
                        projects: projects,
                      ),
                    ),
                    const SizedBox(height: 36),
                    KeyedSubtree(
                      key: _cvKey,
                      child: _CvPreviewSection(
                        locale: widget.locale,
                        document: cv,
                      ),
                    ),
                    const SizedBox(height: 36),
                    KeyedSubtree(
                      key: _contactKey,
                      child: _ContactSection(locale: widget.locale),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      appStrings.footerLine.of(widget.locale),
                      style: Theme.of(context).textTheme.bodyMedium,
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
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.locale,
    required this.onProjectsPressed,
    required this.onCvPressed,
  });

  final AppLocale locale;
  final VoidCallback onProjectsPressed;
  final VoidCallback onCvPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = MediaQuery.sizeOf(context).width < 860;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 24 : 34),
        child: isCompact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _content(theme, isCompact),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _content(theme, isCompact),
                    ),
                  ),
                  const SizedBox(width: 28),
                  const Expanded(
                    flex: 5,
                    child: _HeroVisual(),
                  ),
                ],
              ),
      ),
    );
  }

  List<Widget> _content(ThemeData theme, bool isCompact) {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          profileData.role.of(locale),
          style: theme.textTheme.labelLarge,
        ),
      ),
      const SizedBox(height: 22),
      Text(
        profileData.heroTitle.of(locale),
        style: isCompact ? theme.textTheme.displayMedium : theme.textTheme.displayLarge,
      ),
      const SizedBox(height: 18),
      Text(
        profileData.heroBody.of(locale),
        style: theme.textTheme.bodyLarge,
      ),
      const SizedBox(height: 22),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          FilledButton(
            onPressed: onProjectsPressed,
            child: Text(appStrings.ctaProjects.of(locale)),
          ),
          OutlinedButton(
            onPressed: onCvPressed,
            child: Text(appStrings.ctaCv.of(locale)),
          ),
        ],
      ),
    ];
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.95,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF181818),
              Color(0xFF244B48),
              Color(0xFFCD7A65),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Flutter\nPortfolio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          height: 0.95,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Projects • CV • Product thinking',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.locale});

  final AppLocale locale;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.sectionAbout.of(locale),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            Text(
              profileData.about.of(locale),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: profileData.highlights
                  .map(
                    (highlight) => Chip(
                      label: Text(highlight.of(locale)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profileData.stack
                  .map(
                    (item) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.76),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(item),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({
    required this.locale,
    required this.projects,
  });

  final AppLocale locale;
  final List<ProjectViewModel> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appStrings.projectsEyebrow.of(locale),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          appStrings.sectionProjects.of(locale),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 10),
        Text(
          appStrings.projectsBody.of(locale),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 980
                ? 3
                : constraints.maxWidth >= 700
                    ? 2
                    : 1;
            final itemWidth = (constraints.maxWidth - ((columns - 1) * 18)) / columns;

            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: projects
                  .map(
                    (project) => SizedBox(
                      width: itemWidth,
                      child: _ProjectCard(
                        locale: locale,
                        project: project,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.locale,
    required this.project,
  });

  final AppLocale locale;
  final ProjectViewModel project;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => Navigator.of(context).pushNamed('/projects/${project.meta.slug}'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectPreview(project: project),
              const SizedBox(height: 18),
              SizedBox(
                height: 54,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    project.title(locale),
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 70,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    project.summary(locale),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.meta.stack
                    .map((item) => Chip(label: Text(item)))
                    .toList(),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    appStrings.ctaViewProject.of(locale),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  if (project.hasGithubData)
                    Text(
                      '${project.github!.stars} ${appStrings.githubStars.of(locale)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectPreview extends StatelessWidget {
  const _ProjectPreview({required this.project});

  final ProjectViewModel project;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
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
              top: 18,
              left: 18,
              child: Container(
                width: 86,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.68),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              top: 42,
              left: 18,
              child: Container(
                width: 132,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.38),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CvPreviewSection extends StatelessWidget {
  const _CvPreviewSection({
    required this.locale,
    required this.document,
  });

  final AppLocale locale;
  final CvDocument? document;

  @override
  Widget build(BuildContext context) {
    final firstSection = document?.sections.firstOrNull;
    final previewText = firstSection == null
        ? appStrings.cvPreviewBody.of(locale)
        : _extractPreview(firstSection);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.cvEyebrow.of(locale),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.sectionCv.of(locale),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Text(
              previewText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/cv'),
              child: Text(appStrings.ctaCv.of(locale)),
            ),
          ],
        ),
      ),
    );
  }

  String _extractPreview(CvSection section) {
    for (final entry in section.entries) {
      if (entry.type == CvEntryType.paragraph) {
        return entry.text;
      }
      if (entry.type == CvEntryType.bulletList && entry.bullets.isNotEmpty) {
        return entry.bullets.first;
      }
    }

    return appStrings.cvPreviewBody.of(locale);
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.locale});

  final AppLocale locale;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.sectionContact.of(locale),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              appStrings.contactBody.of(locale),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () => openExternalUrl('mailto:${profileData.email}'),
                  child: Text(profileData.email),
                ),
                OutlinedButton(
                  onPressed: () => openExternalUrl(profileData.githubUrl),
                  child: const Text('GitHub'),
                ),
                OutlinedButton(
                  onPressed: () => openExternalUrl(profileData.linkedinUrl),
                  child: const Text('LinkedIn'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
