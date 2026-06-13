import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Lumenta'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to Lumenta'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in. Check your details and try again.'**
  String get loginError;

  /// No description provided for @tenantPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a workspace'**
  String get tenantPickerTitle;

  /// No description provided for @switchTenant.
  ///
  /// In en, this message translates to:
  /// **'Switch workspace'**
  String get switchTenant;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @navClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get navClients;

  /// No description provided for @navChats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get navChats;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @clientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientsTitle;

  /// No description provided for @searchClients.
  ///
  /// In en, this message translates to:
  /// **'Search clients'**
  String get searchClients;

  /// No description provided for @clientsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No clients yet'**
  String get clientsEmpty;

  /// No description provided for @chatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatsTitle;

  /// No description provided for @chatsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chatsEmpty;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get notificationsEmpty;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @previewPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get previewPhoto;

  /// No description provided for @previewVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get previewVoice;

  /// No description provided for @previewAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get previewAudio;

  /// No description provided for @previewVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get previewVideo;

  /// No description provided for @previewDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get previewDocument;

  /// No description provided for @previewLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get previewLocation;

  /// No description provided for @previewSticker.
  ///
  /// In en, this message translates to:
  /// **'Sticker'**
  String get previewSticker;

  /// No description provided for @previewContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get previewContact;

  /// No description provided for @flowResponseTitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive Response'**
  String get flowResponseTitle;

  /// No description provided for @flowResponseReceived.
  ///
  /// In en, this message translates to:
  /// **'Response received'**
  String get flowResponseReceived;

  /// No description provided for @flowResponseDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Response'**
  String get flowResponseDetailsTitle;

  /// No description provided for @flowFieldColumn.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get flowFieldColumn;

  /// No description provided for @flowValueColumn.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get flowValueColumn;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSent;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get statusRead;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get loadingError;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @transcription.
  ///
  /// In en, this message translates to:
  /// **'Transcription'**
  String get transcription;

  /// No description provided for @openDocument.
  ///
  /// In en, this message translates to:
  /// **'Open document'**
  String get openDocument;

  /// No description provided for @loginNoRecaptcha.
  ///
  /// In en, this message translates to:
  /// **'Login is not configured (missing reCAPTCHA key).'**
  String get loginNoRecaptcha;

  /// No description provided for @composerHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get composerHint;

  /// No description provided for @windowClosed.
  ///
  /// In en, this message translates to:
  /// **'Outside the 24-hour window. Send an approved template to start a new conversation.'**
  String get windowClosed;

  /// No description provided for @attachPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get attachPhoto;

  /// No description provided for @attachCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get attachCamera;

  /// No description provided for @attachDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get attachDocument;

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send. Tap to retry.'**
  String get sendFailed;

  /// No description provided for @senderStartVia.
  ///
  /// In en, this message translates to:
  /// **'Start conversation via…'**
  String get senderStartVia;

  /// No description provided for @senderDefaultTag.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get senderDefaultTag;

  /// No description provided for @senderInactive.
  ///
  /// In en, this message translates to:
  /// **'This number is inactive'**
  String get senderInactive;

  /// No description provided for @senderInactiveComposer.
  ///
  /// In en, this message translates to:
  /// **'This number is inactive — sending is disabled'**
  String get senderInactiveComposer;

  /// No description provided for @senderNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No messages with this number yet. Send one to start the conversation.'**
  String get senderNoHistory;

  /// No description provided for @sendingAs.
  ///
  /// In en, this message translates to:
  /// **'Sending as {name} · {number}'**
  String sendingAs(Object name, Object number);

  /// No description provided for @sendingAsNameOnly.
  ///
  /// In en, this message translates to:
  /// **'Sending as {name}'**
  String sendingAsNameOnly(Object name);

  /// No description provided for @sendTemplate.
  ///
  /// In en, this message translates to:
  /// **'Send a template'**
  String get sendTemplate;

  /// No description provided for @attachTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get attachTemplate;

  /// No description provided for @templatePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a template'**
  String get templatePickerTitle;

  /// No description provided for @templateSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search templates'**
  String get templateSearchHint;

  /// No description provided for @noApprovedTemplates.
  ///
  /// In en, this message translates to:
  /// **'No approved templates'**
  String get noApprovedTemplates;

  /// No description provided for @noApprovedTemplatesHint.
  ///
  /// In en, this message translates to:
  /// **'Create templates in the Lumenta web portal.'**
  String get noApprovedTemplatesHint;

  /// No description provided for @templateFillTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the template'**
  String get templateFillTitle;

  /// No description provided for @templatePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get templatePreview;

  /// No description provided for @templateVarRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill in: {names}'**
  String templateVarRequired(Object names);

  /// No description provided for @templateSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the template. Please try again.'**
  String get templateSendFailed;

  /// No description provided for @templateImageHeader.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get templateImageHeader;

  /// No description provided for @templateVideoHeader.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get templateVideoHeader;

  /// No description provided for @templateDocHeader.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get templateDocHeader;

  /// No description provided for @templateMarketingUsWarning.
  ///
  /// In en, this message translates to:
  /// **'Marketing templates to US numbers may be blocked by Meta.'**
  String get templateMarketingUsWarning;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
