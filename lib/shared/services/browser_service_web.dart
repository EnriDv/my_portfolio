import 'dart:html' as html;

void openExternalUrl(String url) {
  html.window.open(url, '_blank', 'noopener,noreferrer');
}

void downloadBytes({
  required List<int> bytes,
  required String fileName,
  required String mimeType,
}) {
  final blob = html.Blob([bytes], mimeType);
  final objectUrl = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: objectUrl)
    ..download = fileName
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(objectUrl);
}
