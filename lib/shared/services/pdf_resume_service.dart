import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/content/app_content.dart';
import '../../data/models/cv_models.dart';

class PdfResumeService {
  Future<List<int>> buildPdf({
    required CvDocument document,
    required ProfileData profile,
    required AppLocale locale,
  }) async {
    final pdf = pw.Document(
      title: '${profile.name} CV',
      author: profile.name,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(36),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        build: (context) {
          return [
            pw.Text(
              profile.name,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              profile.role.of(locale),
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '${profile.location} · ${profile.email}',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 22),
            ...document.sections.expand((section) sync* {
              yield pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  section.title,
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              );

              for (final entry in section.entries) {
                switch (entry.type) {
                  case CvEntryType.paragraph:
                    yield pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 10),
                      child: pw.Text(
                        entry.text,
                        style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 3),
                      ),
                    );
                  case CvEntryType.subheading:
                    yield pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Text(
                        entry.text,
                        style: pw.TextStyle(
                          fontSize: 11.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    );
                  case CvEntryType.bulletList:
                    yield pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: entry.bullets
                            .map(
                              (bullet) => pw.Bullet(
                                text: bullet,
                                style: const pw.TextStyle(fontSize: 10.5),
                              ),
                            )
                            .toList(),
                      ),
                    );
                }
              }

              yield pw.SizedBox(height: 10);
            }),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
