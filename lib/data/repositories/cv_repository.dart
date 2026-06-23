import 'package:flutter/services.dart';

import '../content/app_content.dart';
import '../models/cv_models.dart';

class CvRepository {
  Future<CvDocument> load(AppLocale locale) async {
    final raw = await rootBundle.loadString('assets/content/cv.md');
    return CvMarkdownParser.parse(
      raw,
      localeCode: locale.code,
    );
  }
}

class CvMarkdownParser {
  static CvDocument parse(String source, {required String localeCode}) {
    final localizedBlocks = _splitLocaleBlocks(source);
    final content = localizedBlocks[localeCode] ?? localizedBlocks['es'] ?? '';
    final sections = <CvSection>[];

    String? currentTitle;
    final currentEntries = <CvEntry>[];
    final paragraphBuffer = <String>[];
    final bulletBuffer = <String>[];

    void flushParagraph() {
      if (paragraphBuffer.isEmpty) {
        return;
      }
      currentEntries.add(CvEntry.paragraph(paragraphBuffer.join(' ')));
      paragraphBuffer.clear();
    }

    void flushBullets() {
      if (bulletBuffer.isEmpty) {
        return;
      }
      currentEntries.add(CvEntry.bulletList(List<String>.from(bulletBuffer)));
      bulletBuffer.clear();
    }

    void flushSection() {
      flushParagraph();
      flushBullets();
      if (currentTitle != null) {
        sections.add(CvSection(
          title: currentTitle!,
          entries: List<CvEntry>.from(currentEntries),
        ));
      }
      currentEntries.clear();
    }

    for (final rawLine in content.split('\n')) {
      final line = rawLine.trimRight();
      final trimmed = line.trim();

      if (trimmed.startsWith('## ')) {
        flushSection();
        currentTitle = trimmed.substring(3).trim();
        continue;
      }

      if (trimmed.isEmpty) {
        flushParagraph();
        flushBullets();
        continue;
      }

      if (trimmed.startsWith('### ')) {
        flushParagraph();
        flushBullets();
        currentEntries.add(CvEntry.subheading(trimmed.substring(4).trim()));
        continue;
      }

      if (trimmed.startsWith('- ')) {
        flushParagraph();
        bulletBuffer.add(trimmed.substring(2).trim());
        continue;
      }

      paragraphBuffer.add(trimmed);
    }

    flushSection();

    return CvDocument(
      localeCode: localeCode,
      sections: sections,
    );
  }

  static Map<String, String> _splitLocaleBlocks(String source) {
    final lines = source.split('\n');
    final blocks = <String, StringBuffer>{};
    String? currentLocale;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('# ')) {
        final candidate = trimmed.substring(2).trim().toLowerCase();
        if (candidate == 'es' || candidate == 'en') {
          currentLocale = candidate;
          blocks.putIfAbsent(candidate, StringBuffer.new);
          continue;
        }
      }

      if (currentLocale != null) {
        blocks[currentLocale]!.writeln(line);
      }
    }

    return blocks.map((key, value) => MapEntry(key, value.toString()));
  }
}
