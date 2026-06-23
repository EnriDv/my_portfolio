import 'browser_service_stub.dart'
    if (dart.library.html) 'browser_service_web.dart' as browser;

void openExternalUrl(String url) => browser.openExternalUrl(url);

void downloadBytes({
  required List<int> bytes,
  required String fileName,
  required String mimeType,
}) {
  browser.downloadBytes(
    bytes: bytes,
    fileName: fileName,
    mimeType: mimeType,
  );
}
