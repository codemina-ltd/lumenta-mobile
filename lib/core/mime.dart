/// File extension for a media MIME type — for naming downloaded/shared
/// message media. Long vendor subtypes (Office formats) are mapped
/// explicitly; for the rest the subtype itself is the extension
/// (image/png → png, video/mp4 → mp4, audio/aac → aac, …).
String extensionForMime(String? mime, {String fallback = 'bin'}) {
  switch (mime) {
    case 'image/jpeg':
      return 'jpg';
    case 'audio/mpeg':
      return 'mp3';
    case 'audio/ogg':
    case 'audio/ogg; codecs=opus':
      return 'ogg';
    case 'application/pdf':
      return 'pdf';
    case 'application/msword':
      return 'doc';
    case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      return 'docx';
    case 'application/vnd.ms-excel':
      return 'xls';
    case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
      return 'xlsx';
    case 'application/vnd.ms-powerpoint':
      return 'ppt';
    case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
      return 'pptx';
    case 'text/plain':
      return 'txt';
    case 'text/csv':
      return 'csv';
    case null:
      return fallback;
    default:
      final subtype = mime.split('/').last.split(';').first.trim();
      return subtype.isEmpty ? fallback : subtype;
  }
}
