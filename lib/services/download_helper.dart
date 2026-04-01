/// Platform-agnostic download helper.
/// On web, uses dart:html. In tests, this is a no-op stub.
abstract class DownloadHelper {
  void download(String content, String filename, String mimeType);
}
