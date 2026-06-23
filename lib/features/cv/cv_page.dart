import 'package:flutter/material.dart';

import '../../data/content/app_content.dart';
import '../../data/models/cv_models.dart';
import '../../data/repositories/cv_repository.dart';
import '../../shared/services/browser_service.dart';
import '../../shared/services/pdf_resume_service.dart';
import '../../shared/widgets/portfolio_scaffold.dart';

class CvPage extends StatefulWidget {
  const CvPage({
    super.key,
    required this.locale,
    required this.onToggleLocale,
    required this.cvRepository,
  });

  final AppLocale locale;
  final VoidCallback onToggleLocale;
  final CvRepository cvRepository;

  @override
  State<CvPage> createState() => _CvPageState();
}

class _CvPageState extends State<CvPage> {
  final _pdfService = PdfResumeService();
  bool _downloading = false;

  Future<void> _download(CvDocument document) async {
    setState(() {
      _downloading = true;
    });

    try {
      final bytes = await _pdfService.buildPdf(
        document: document,
        profile: profileData,
        locale: widget.locale,
      );
      downloadBytes(
        bytes: bytes,
        fileName: profileData.cvFileName,
        mimeType: 'application/pdf',
      );
    } finally {
      if (mounted) {
        setState(() {
          _downloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PortfolioScaffold(
      locale: widget.locale,
      onToggleLocale: widget.onToggleLocale,
      currentRoute: '/cv',
      body: FutureBuilder<CvDocument>(
        future: widget.cvRepository.load(widget.locale),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final document = snapshot.data!;
          final isWide = MediaQuery.sizeOf(context).width > 980;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData.name,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profileData.role.of(widget.locale),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              appStrings.cvPageIntro.of(widget.locale),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton(
                                  onPressed: _downloading ? null : () => _download(document),
                                  child: Text(
                                    _downloading
                                        ? '...'
                                        : appStrings.ctaDownloadCv.of(widget.locale),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () => Navigator.of(context).pushNamed('/'),
                                  child: Text(appStrings.cvBackHome.of(widget.locale)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250,
                            child: _CvToc(
                              locale: widget.locale,
                              document: document,
                            ),
                          ),
                          const SizedBox(width: 22),
                          Expanded(
                            child: _CvDocumentView(document: document),
                          ),
                        ],
                      )
                    else ...[
                      _CvToc(
                        locale: widget.locale,
                        document: document,
                      ),
                      const SizedBox(height: 22),
                      _CvDocumentView(document: document),
                    ],
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

class _CvToc extends StatelessWidget {
  const _CvToc({
    required this.locale,
    required this.document,
  });

  final AppLocale locale;
  final CvDocument document;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.cvToc.of(locale),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...document.sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  section.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CvDocumentView extends StatelessWidget {
  const _CvDocumentView({required this.document});

  final CvDocument document;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: document.sections
              .map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 14),
                      ...section.entries.map(_buildEntry),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildEntry(CvEntry entry) {
    switch (entry.type) {
      case CvEntryType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Builder(
            builder: (context) => Text(
              entry.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      case CvEntryType.subheading:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Builder(
            builder: (context) => Text(
              entry.text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        );
      case CvEntryType.bulletList:
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entry.bullets
                .map(
                  (bullet) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Builder(
                      builder: (context) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(Icons.circle, size: 8),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              bullet,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
    }
  }
}
