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
  String get navInbox => 'Boîte';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get inboxViewMine => 'Les miennes';

  @override
  String get inboxViewUnassigned => 'Non attribuées';

  @override
  String get inboxViewOpen => 'Ouvertes';

  @override
  String get inboxViewSnoozed => 'Reportées';

  @override
  String get inboxViewAll => 'Toutes';

  @override
  String get inboxEmpty => 'Aucune conversation ne correspond à cette vue';

  @override
  String get inboxAssignToMe => 'M\'attribuer';

  @override
  String get inboxStatusResolved => 'Marquer résolue';

  @override
  String get inboxStatusPending => 'Marquer en attente';

  @override
  String get inboxAddNote => 'Ajouter une note interne';

  @override
  String get inboxNoteHint => 'Note interne — le client ne la voit jamais';

  @override
  String get inboxActionFailed =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get inboxCancel => 'Annuler';

  @override
  String get inboxSave => 'Enregistrer';

  @override
  String get inboxReopen => 'Rouvrir';

  @override
  String get inboxAssignToMember => 'Attribuer à un membre…';

  @override
  String get inboxUnassign => 'Retirer l\'attribution';

  @override
  String get inboxSnoozeUntil => 'Reporter jusqu\'à…';

  @override
  String get inboxPriority => 'Priorité';

  @override
  String get inboxPriorityLow => 'Basse';

  @override
  String get inboxPriorityNormal => 'Normale';

  @override
  String get inboxPriorityHigh => 'Haute';

  @override
  String get inboxLabels => 'Étiquettes';

  @override
  String get inboxNoLabels => 'Aucune étiquette pour l\'instant';

  @override
  String get inboxAssigneeUnassigned => 'Non attribuée';

  @override
  String get contactDetails => 'Détails du contact';

  @override
  String get contactLifecycle => 'Étape du cycle de vie';

  @override
  String get contactNoStage => 'Aucune étape';

  @override
  String get contactOptIn => 'Consentement marketing';

  @override
  String get contactFields => 'Champs personnalisés';

  @override
  String get contactNoFields => 'Aucun champ personnalisé';

  @override
  String get contactLoadError =>
      'Impossible de charger les détails du contact.';

  @override
  String get contactSaveFailed =>
      'Échec de l\'enregistrement. Veuillez réessayer.';

  @override
  String get contactCameFrom => 'Provient de :';

  @override
  String get ordersTitle => 'Commandes';

  @override
  String get ordersEmpty => 'Aucune commande pour ce contact';

  @override
  String get ordersActionFailed =>
      'Échec de la mise à jour. Veuillez réessayer.';

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

  @override
  String get profileTitle => 'Profil';

  @override
  String get profilePictureTitle => 'Photo de profil';

  @override
  String get profileUploadPicture => 'Importer une photo';

  @override
  String get profileRemovePicture => 'Supprimer';

  @override
  String get profileIdentityTitle => 'Identité';

  @override
  String get profileFullNameLabel => 'Nom complet';

  @override
  String get profileNameTooShort => 'Saisissez au moins 2 caractères';

  @override
  String get profilePhoneLabel => 'Numéro de téléphone';

  @override
  String get profilePhoneHelper =>
      'Format international, chiffres uniquement (indicatif pays, sans signe +).';

  @override
  String get profilePhoneInvalid =>
      'Chiffres uniquement : indicatif + numéro (7 à 15 chiffres)';

  @override
  String get profileLanguageLabel => 'Langue';

  @override
  String get profileTimezoneLabel => 'Fuseau horaire';

  @override
  String get profileTimezoneSearchHint => 'Rechercher un fuseau horaire';

  @override
  String get profileSaveChanges => 'Enregistrer les modifications';

  @override
  String get profileSaved => 'Profil mis à jour';

  @override
  String get profileSaveFailed =>
      'Enregistrement impossible. Veuillez réessayer.';

  @override
  String get profileAppearanceTitle => 'Apparence';

  @override
  String get profileFontLabel => 'Police d\'affichage';

  @override
  String get profileFontHelper =>
      'Utilisée dans le portail pour l\'anglais et le français.';

  @override
  String get profileSaveFont => 'Enregistrer la police';

  @override
  String get profileFontSaved => 'Police mise à jour';

  @override
  String get profileEmailTitle => 'Adresse e-mail';

  @override
  String get profileCurrentEmail => 'E-mail actuel';

  @override
  String get profileChangeEmail => 'Changer d\'e-mail';

  @override
  String get profileNewEmailLabel => 'Nouvel e-mail';

  @override
  String get profileEmailInvalid => 'Saisissez une adresse e-mail valide';

  @override
  String profileEmailPending(Object email) {
    return 'En attente de confirmation de $email';
  }

  @override
  String profileEmailChangeRequested(Object email) {
    return 'Lien de confirmation envoyé à $email. Il expire dans 24 heures.';
  }

  @override
  String get profileEmailTaken => 'Cette adresse e-mail est déjà enregistrée.';

  @override
  String get profileEmailChangeInvalid =>
      'La demande de changement d\'e-mail est invalide ou a expiré.';

  @override
  String get profileSendLink => 'Envoyer le lien';

  @override
  String get profilePasswordTitle => 'Mot de passe';

  @override
  String get profileCurrentPasswordLabel => 'Mot de passe actuel';

  @override
  String get profileNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get profileConfirmPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get profileUpdatePassword => 'Mettre à jour le mot de passe';

  @override
  String get profilePasswordUpdated =>
      'Mot de passe mis à jour. Les autres appareils ont été déconnectés.';

  @override
  String get profilePasswordMin => 'Au moins 8 caractères';

  @override
  String get profilePasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get profilePasswordIncorrect =>
      'Le mot de passe actuel est incorrect.';

  @override
  String get profileFieldRequired => 'Obligatoire';

  @override
  String get profileAvatarTooLarge =>
      'L\'image est trop volumineuse (2 Mo max).';

  @override
  String get profileAvatarInvalidType =>
      'Type d\'image non pris en charge. Utilisez PNG, JPG, GIF ou WebP.';

  @override
  String get cancel => 'Annuler';

  @override
  String get messageActionCopy => 'Copier';

  @override
  String get messageActionForward => 'Transférer';

  @override
  String get messageActionShare => 'Partager';

  @override
  String get messageCopied => 'Copié dans le presse-papiers';

  @override
  String get forwardTitle => 'Transférer à…';

  @override
  String forwardSent(Object name) {
    return 'Transféré à $name';
  }

  @override
  String get forwardFailed => 'Impossible de transférer. Veuillez réessayer.';

  @override
  String get shareFailed => 'Impossible de partager. Veuillez réessayer.';

  @override
  String get reactionFailed =>
      'Impossible d\'envoyer la réaction. Veuillez réessayer.';

  @override
  String get messageActionDeleteForMe => 'Supprimer pour moi';

  @override
  String get messageActionDeleteForEveryone => 'Supprimer pour tout le monde';

  @override
  String get deleteMessageTitle => 'Supprimer le message ?';

  @override
  String get deleteForMeConfirm =>
      'Ce message sera retiré de votre vue uniquement. Les autres membres de l\'équipe le verront toujours.';

  @override
  String get deleteForEveryoneConfirm =>
      'Ce message sera supprimé pour tous les membres de l\'équipe. Le client conservera sa copie sur WhatsApp.';

  @override
  String get deleteConfirmAction => 'Supprimer';

  @override
  String get deleteMessageFailed =>
      'Impossible de supprimer le message. Veuillez réessayer.';

  @override
  String get messageDeleted => 'Ce message a été supprimé';

  @override
  String get navReminders => 'Rappels';

  @override
  String get remindersOverdue => 'En retard';

  @override
  String get remindersToday => 'Aujourd\'hui';

  @override
  String get remindersUpcoming => 'À venir';

  @override
  String get remindersEmptyTitle => 'Tout est à jour';

  @override
  String get remindersEmptyBody =>
      'Aucun rappel ouvert ne vous est assigné. Créez-les depuis le portail ou la conversation.';

  @override
  String get reminderComplete => 'Marquer comme fait';

  @override
  String get reminderCompleted => 'Rappel terminé';

  @override
  String get reminderSnooze15m => 'Reporter de 15 minutes';

  @override
  String get reminderSnooze1h => 'Reporter d\'1 heure';

  @override
  String get reminderSnooze3h => 'Reporter de 3 heures';

  @override
  String get reminderSnoozeTomorrow => 'Reporter à demain 9h00';

  @override
  String get reminderSnoozed => 'Rappel reporté';

  @override
  String get reminderActionFailed =>
      'Une erreur est survenue — veuillez réessayer';

  @override
  String get reminderOpenConversation => 'Ouvrir la conversation';

  @override
  String get reminderOverdueLabel => 'En retard';

  @override
  String get reminderActions => 'Actions du rappel';
}
