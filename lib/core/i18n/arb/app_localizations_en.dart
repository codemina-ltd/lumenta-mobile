// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lumenta';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Welcome back to Lumenta';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginError =>
      'Couldn\'t sign in. Check your details and try again.';

  @override
  String get tenantPickerTitle => 'Choose a workspace';

  @override
  String get switchTenant => 'Switch workspace';

  @override
  String get logout => 'Log out';

  @override
  String get navClients => 'Clients';

  @override
  String get navChats => 'Chats';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get clientsTitle => 'Clients';

  @override
  String get searchClients => 'Search clients';

  @override
  String get clientsEmpty => 'No clients yet';

  @override
  String get chatsTitle => 'Chats';

  @override
  String get chatsEmpty => 'No conversations yet';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'You\'re all caught up';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get previewPhoto => 'Photo';

  @override
  String get previewVoice => 'Voice note';

  @override
  String get previewAudio => 'Audio';

  @override
  String get previewVideo => 'Video';

  @override
  String get previewDocument => 'Document';

  @override
  String get previewLocation => 'Location';

  @override
  String get previewSticker => 'Sticker';

  @override
  String get previewContact => 'Contact';

  @override
  String get statusSent => 'Sent';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusRead => 'Read';

  @override
  String get statusFailed => 'Failed';

  @override
  String get retry => 'Retry';

  @override
  String get loadingError => 'Something went wrong';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get transcription => 'Transcription';

  @override
  String get openDocument => 'Open document';

  @override
  String get loginNoRecaptcha =>
      'Login is not configured (missing reCAPTCHA key).';
}
