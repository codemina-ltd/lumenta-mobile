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
  String get flowResponseTitle => 'Réponse interactive';

  @override
  String get flowResponseReceived => 'Réponse reçue';

  @override
  String get flowResponseDetailsTitle => 'Détails de la réponse du client';

  @override
  String get flowFieldColumn => 'Champ';

  @override
  String get flowValueColumn => 'Valeur';

  @override
  String get close => 'Fermer';

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

  @override
  String get composerHint => 'Message';

  @override
  String get windowClosed =>
      'Hors de la fenêtre de 24 heures. Envoyez un modèle approuvé pour démarrer une nouvelle conversation.';

  @override
  String get attachPhoto => 'Photo';

  @override
  String get attachCamera => 'Appareil photo';

  @override
  String get attachDocument => 'Document';

  @override
  String get sendFailed => 'Échec de l\'envoi. Appuyez pour réessayer.';

  @override
  String get senderStartVia => 'Démarrer une conversation via…';

  @override
  String get senderDefaultTag => 'Par défaut';

  @override
  String get senderInactive => 'Ce numéro est inactif';

  @override
  String get senderInactiveComposer =>
      'Ce numéro est inactif — l\'envoi est désactivé';

  @override
  String get senderNoHistory =>
      'Aucun message via ce numéro pour le moment. Envoyez-en un pour démarrer la conversation.';

  @override
  String sendingAs(Object name, Object number) {
    return 'Envoi en tant que $name · $number';
  }

  @override
  String sendingAsNameOnly(Object name) {
    return 'Envoi en tant que $name';
  }

  @override
  String get sendTemplate => 'Envoyer un modèle';

  @override
  String get attachTemplate => 'Modèle';

  @override
  String get templatePickerTitle => 'Choisir un modèle';

  @override
  String get templateSearchHint => 'Rechercher des modèles';

  @override
  String get noApprovedTemplates => 'Aucun modèle approuvé';

  @override
  String get noApprovedTemplatesHint =>
      'Créez des modèles dans le portail web Lumenta.';

  @override
  String get templateFillTitle => 'Remplir le modèle';

  @override
  String get templatePreview => 'Aperçu';

  @override
  String templateVarRequired(Object names) {
    return 'Veuillez remplir : $names';
  }

  @override
  String get templateSendFailed =>
      'Échec de l\'envoi du modèle. Veuillez réessayer.';

  @override
  String get templateImageHeader => 'Image';

  @override
  String get templateVideoHeader => 'Vidéo';

  @override
  String get templateDocHeader => 'Document';

  @override
  String get templateMarketingUsWarning =>
      'Les modèles marketing vers des numéros américains peuvent être bloqués par Meta.';
}
