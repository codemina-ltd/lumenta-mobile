// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Lumenta';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginSubtitle => 'Content de vous revoir sur Lumenta';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginError =>
      'Connexion impossible. Vérifiez vos informations et réessayez.';

  @override
  String get tenantPickerTitle => 'Choisir un espace de travail';

  @override
  String get switchTenant => 'Changer d\'espace';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get navClients => 'Clients';

  @override
  String get navChats => 'Discussions';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get clientsTitle => 'Clients';

  @override
  String get searchClients => 'Rechercher des clients';

  @override
  String get clientsEmpty => 'Aucun client pour le moment';

  @override
  String get chatsTitle => 'Discussions';

  @override
  String get chatsEmpty => 'Aucune conversation pour le moment';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'Vous êtes à jour';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get previewPhoto => 'Photo';

  @override
  String get previewVoice => 'Note vocale';

  @override
  String get previewAudio => 'Audio';

  @override
  String get previewVideo => 'Vidéo';

  @override
  String get previewDocument => 'Document';

  @override
  String get previewLocation => 'Position';

  @override
  String get previewSticker => 'Sticker';

  @override
  String get previewContact => 'Contact';

  @override
  String get statusSent => 'Envoyé';

  @override
  String get statusDelivered => 'Distribué';

  @override
  String get statusRead => 'Lu';

  @override
  String get statusFailed => 'Échec';

  @override
  String get retry => 'Réessayer';

  @override
  String get loadingError => 'Une erreur est survenue';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get transcription => 'Transcription';

  @override
  String get openDocument => 'Ouvrir le document';

  @override
  String get loginNoRecaptcha =>
      'La connexion n\'est pas configurée (clé reCAPTCHA manquante).';
}
