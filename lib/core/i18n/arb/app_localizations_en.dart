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
  String get navInbox => 'Inbox';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get inboxViewMine => 'Mine';

  @override
  String get inboxViewUnassigned => 'Unassigned';

  @override
  String get inboxViewOpen => 'Open';

  @override
  String get inboxViewSnoozed => 'Snoozed';

  @override
  String get inboxViewAll => 'All';

  @override
  String get inboxEmpty => 'No conversations match this view';

  @override
  String get inboxAssignToMe => 'Assign to me';

  @override
  String get inboxStatusResolved => 'Mark resolved';

  @override
  String get inboxStatusPending => 'Mark pending';

  @override
  String get inboxAddNote => 'Add internal note';

  @override
  String get inboxNoteHint => 'Internal note — the customer never sees it';

  @override
  String get inboxActionFailed => 'Something went wrong. Please try again.';

  @override
  String get inboxCancel => 'Cancel';

  @override
  String get inboxSave => 'Save';

  @override
  String get contactDetails => 'Contact details';

  @override
  String get contactLifecycle => 'Lifecycle stage';

  @override
  String get contactNoStage => 'No stage';

  @override
  String get contactOptIn => 'Marketing opt-in';

  @override
  String get contactFields => 'Custom fields';

  @override
  String get contactNoFields => 'No custom fields';

  @override
  String get contactLoadError => 'Couldn\'t load contact details.';

  @override
  String get contactSaveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get contactCameFrom => 'Came from:';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get ordersEmpty => 'No orders for this contact';

  @override
  String get ordersActionFailed => 'Couldn\'t update. Please try again.';

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
  String get flowResponseTitle => 'Interactive Response';

  @override
  String get flowResponseReceived => 'Response received';

  @override
  String get flowResponseDetailsTitle => 'Customer Response';

  @override
  String get flowFieldColumn => 'Field';

  @override
  String get flowValueColumn => 'Value';

  @override
  String get close => 'Close';

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

  @override
  String get composerHint => 'Message';

  @override
  String get windowClosed =>
      'Outside the 24-hour window. Send an approved template to start a new conversation.';

  @override
  String get attachPhoto => 'Photo';

  @override
  String get attachCamera => 'Camera';

  @override
  String get attachDocument => 'Document';

  @override
  String get sendFailed => 'Couldn\'t send. Tap to retry.';

  @override
  String get senderStartVia => 'Start conversation via…';

  @override
  String get senderDefaultTag => 'Default';

  @override
  String get senderInactive => 'This number is inactive';

  @override
  String get senderInactiveComposer =>
      'This number is inactive — sending is disabled';

  @override
  String get senderNoHistory =>
      'No messages with this number yet. Send one to start the conversation.';

  @override
  String sendingAs(Object name, Object number) {
    return 'Sending as $name · $number';
  }

  @override
  String sendingAsNameOnly(Object name) {
    return 'Sending as $name';
  }

  @override
  String get sendTemplate => 'Send a template';

  @override
  String get attachTemplate => 'Template';

  @override
  String get templatePickerTitle => 'Choose a template';

  @override
  String get templateSearchHint => 'Search templates';

  @override
  String get noApprovedTemplates => 'No approved templates';

  @override
  String get noApprovedTemplatesHint =>
      'Create templates in the Lumenta web portal.';

  @override
  String get templateFillTitle => 'Fill in the template';

  @override
  String get templatePreview => 'Preview';

  @override
  String templateVarRequired(Object names) {
    return 'Please fill in: $names';
  }

  @override
  String get templateSendFailed =>
      'Couldn\'t send the template. Please try again.';

  @override
  String get templateImageHeader => 'Image';

  @override
  String get templateVideoHeader => 'Video';

  @override
  String get templateDocHeader => 'Document';

  @override
  String get templateMarketingUsWarning =>
      'Marketing templates to US numbers may be blocked by Meta.';

  @override
  String get messageActionCopy => 'Copy';

  @override
  String get messageActionForward => 'Forward';

  @override
  String get messageActionShare => 'Share';

  @override
  String get messageCopied => 'Copied to clipboard';

  @override
  String get forwardTitle => 'Forward to…';

  @override
  String forwardSent(Object name) {
    return 'Forwarded to $name';
  }

  @override
  String get forwardFailed => 'Couldn\'t forward. Please try again.';

  @override
  String get shareFailed => 'Couldn\'t share. Please try again.';
}
