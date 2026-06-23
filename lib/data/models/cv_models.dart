class CvDocument {
  const CvDocument({
    required this.localeCode,
    required this.sections,
  });

  final String localeCode;
  final List<CvSection> sections;
}

class CvSection {
  const CvSection({
    required this.title,
    required this.entries,
  });

  final String title;
  final List<CvEntry> entries;
}

enum CvEntryType { paragraph, bulletList, subheading }

class CvEntry {
  const CvEntry.paragraph(this.text)
      : type = CvEntryType.paragraph,
        bullets = const [];

  const CvEntry.subheading(this.text)
      : type = CvEntryType.subheading,
        bullets = const [];

  const CvEntry.bulletList(this.bullets)
      : type = CvEntryType.bulletList,
        text = '';

  final CvEntryType type;
  final String text;
  final List<String> bullets;
}
