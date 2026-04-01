import 'download_helper.dart';

class StubDownloadHelper implements DownloadHelper {
  @override
  void download(String content, String filename, String mimeType) {
    // No-op on non-web platforms
  }
}

DownloadHelper createDownloadHelper() => StubDownloadHelper();
