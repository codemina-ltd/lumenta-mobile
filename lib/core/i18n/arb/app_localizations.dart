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

  /// No description provided for @navInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get navInbox;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @inboxViewMine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get inboxViewMine;

  /// No description provided for @inboxViewUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get inboxViewUnassigned;

  /// No description provided for @inboxViewOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get inboxViewOpen;

  /// No description provided for @inboxViewSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get inboxViewSnoozed;

  /// No description provided for @inboxViewAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get inboxViewAll;

  /// No description provided for @inboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations match this view'**
  String get inboxEmpty;

  /// No description provided for @inboxAssignToMe.
  ///
  /// In en, this message translates to:
  /// **'Assign to me'**
  String get inboxAssignToMe;

  /// No description provided for @inboxStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Mark resolved'**
  String get inboxStatusResolved;

  /// No description provided for @inboxStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Mark pending'**
  String get inboxStatusPending;

  /// No description provided for @inboxAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add internal note'**
  String get inboxAddNote;

  /// No description provided for @inboxNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Internal note — the customer never sees it'**
  String get inboxNoteHint;

  /// No description provided for @inboxMentionHint.
  ///
  /// In en, this message translates to:
  /// **'Type @ to mention a teammate'**
  String get inboxMentionHint;

  /// No description provided for @inboxMentionNotFound.
  ///
  /// In en, this message translates to:
  /// **'No teammates match'**
  String get inboxMentionNotFound;

  /// No description provided for @inboxActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get inboxActionFailed;

  /// No description provided for @inboxCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get inboxCancel;

  /// No description provided for @inboxSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get inboxSave;

  /// No description provided for @inboxReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get inboxReopen;

  /// No description provided for @inboxAssignToMember.
  ///
  /// In en, this message translates to:
  /// **'Assign to member…'**
  String get inboxAssignToMember;

  /// No description provided for @inboxUnassign.
  ///
  /// In en, this message translates to:
  /// **'Unassign'**
  String get inboxUnassign;

  /// No description provided for @inboxSnoozeUntil.
  ///
  /// In en, this message translates to:
  /// **'Snooze until…'**
  String get inboxSnoozeUntil;

  /// No description provided for @inboxPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get inboxPriority;

  /// No description provided for @inboxPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get inboxPriorityLow;

  /// No description provided for @inboxPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get inboxPriorityNormal;

  /// No description provided for @inboxPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get inboxPriorityHigh;

  /// No description provided for @inboxLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get inboxLabels;

  /// No description provided for @inboxNoLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels defined yet'**
  String get inboxNoLabels;

  /// No description provided for @inboxAssigneeUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get inboxAssigneeUnassigned;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contactDetails;

  /// No description provided for @contactLifecycle.
  ///
  /// In en, this message translates to:
  /// **'Lifecycle stage'**
  String get contactLifecycle;

  /// No description provided for @contactNoStage.
  ///
  /// In en, this message translates to:
  /// **'No stage'**
  String get contactNoStage;

  /// No description provided for @contactOptIn.
  ///
  /// In en, this message translates to:
  /// **'Marketing opt-in'**
  String get contactOptIn;

  /// No description provided for @contactFields.
  ///
  /// In en, this message translates to:
  /// **'Custom fields'**
  String get contactFields;

  /// No description provided for @contactNoFields.
  ///
  /// In en, this message translates to:
  /// **'No custom fields'**
  String get contactNoFields;

  /// No description provided for @contactLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load contact details.'**
  String get contactLoadError;

  /// No description provided for @contactSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get contactSaveFailed;

  /// No description provided for @contactCameFrom.
  ///
  /// In en, this message translates to:
  /// **'Came from:'**
  String get contactCameFrom;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @ordersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders for this contact'**
  String get ordersEmpty;

  /// No description provided for @ordersActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update. Please try again.'**
  String get ordersActionFailed;

  /// No description provided for @clientDetailCallsTitle.
  ///
  /// In en, this message translates to:
  /// **'Calls'**
  String get clientDetailCallsTitle;

  /// No description provided for @clientDetailCallsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No calls for this contact'**
  String get clientDetailCallsEmpty;

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

  /// No description provided for @searchGlobalTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchGlobalTitle;

  /// No description provided for @searchGlobalHint.
  ///
  /// In en, this message translates to:
  /// **'Search clients, messages, notes…'**
  String get searchGlobalHint;

  /// No description provided for @searchMinChars.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search across clients, messages, notes and more'**
  String get searchMinChars;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matches for “{query}”'**
  String searchNoResults(Object query);

  /// No description provided for @searchSourceCustomField.
  ///
  /// In en, this message translates to:
  /// **'Custom field'**
  String get searchSourceCustomField;

  /// No description provided for @searchSourceMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get searchSourceMessage;

  /// No description provided for @searchSourceNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get searchSourceNote;

  /// No description provided for @searchSourceHeadline.
  ///
  /// In en, this message translates to:
  /// **'Ad headline'**
  String get searchSourceHeadline;

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

  /// No description provided for @chatAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign to team member'**
  String get chatAssign;

  /// No description provided for @chatSentBy.
  ///
  /// In en, this message translates to:
  /// **'Sent by {name}'**
  String chatSentBy(Object name);

  /// No description provided for @chatSentByHint.
  ///
  /// In en, this message translates to:
  /// **'Only your team can see who sent a message.'**
  String get chatSentByHint;

  /// No description provided for @chatNoteAdded.
  ///
  /// In en, this message translates to:
  /// **'Internal note added'**
  String get chatNoteAdded;

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

  /// No description provided for @contactAndOthers.
  ///
  /// In en, this message translates to:
  /// **'{name} and {count, plural, one{# other} other{# others}}'**
  String contactAndOthers(Object name, num count);

  /// No description provided for @contactViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View contact'**
  String get contactViewDetails;

  /// No description provided for @contactsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get contactsViewAll;

  /// No description provided for @contactDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared contacts'**
  String get contactDetailsTitle;

  /// No description provided for @contactNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'Number copied'**
  String get contactNumberCopied;

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

  /// No description provided for @openVideo.
  ///
  /// In en, this message translates to:
  /// **'Open video'**
  String get openVideo;

  /// No description provided for @documentOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the document. Please try again.'**
  String get documentOpenFailed;

  /// No description provided for @videoOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the video. Please try again.'**
  String get videoOpenFailed;

  /// No description provided for @documentNoApp.
  ///
  /// In en, this message translates to:
  /// **'No app on this device can open this file type.'**
  String get documentNoApp;

  /// No description provided for @mediaExpired.
  ///
  /// In en, this message translates to:
  /// **'This media has expired and is no longer available.'**
  String get mediaExpired;

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

  /// No description provided for @templateSeeAllOptions.
  ///
  /// In en, this message translates to:
  /// **'See all options'**
  String get templateSeeAllOptions;

  /// No description provided for @templateAllOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'All options'**
  String get templateAllOptionsTitle;

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

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profilePictureTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get profilePictureTitle;

  /// No description provided for @profileUploadPicture.
  ///
  /// In en, this message translates to:
  /// **'Upload picture'**
  String get profileUploadPicture;

  /// No description provided for @profileRemovePicture.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get profileRemovePicture;

  /// No description provided for @profileIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get profileIdentityTitle;

  /// No description provided for @profileFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileFullNameLabel;

  /// No description provided for @profileNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters'**
  String get profileNameTooShort;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profilePhoneLabel;

  /// No description provided for @profilePhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'International format, digits only (country code, no + sign).'**
  String get profilePhoneHelper;

  /// No description provided for @profilePhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Digits only: country code + number (7–15 digits)'**
  String get profilePhoneInvalid;

  /// No description provided for @profileLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguageLabel;

  /// No description provided for @profileTimezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get profileTimezoneLabel;

  /// No description provided for @profileTimezoneSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search time zones'**
  String get profileTimezoneSearchHint;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSaveChanges;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileSaved;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get profileSaveFailed;

  /// No description provided for @profileAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearanceTitle;

  /// No description provided for @profileFontLabel.
  ///
  /// In en, this message translates to:
  /// **'Display font'**
  String get profileFontLabel;

  /// No description provided for @profileFontHelper.
  ///
  /// In en, this message translates to:
  /// **'Used across the portal for English and French.'**
  String get profileFontHelper;

  /// No description provided for @profileSaveFont.
  ///
  /// In en, this message translates to:
  /// **'Save font'**
  String get profileSaveFont;

  /// No description provided for @profileFontSaved.
  ///
  /// In en, this message translates to:
  /// **'Font updated'**
  String get profileFontSaved;

  /// No description provided for @profileEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get profileEmailTitle;

  /// No description provided for @profileCurrentEmail.
  ///
  /// In en, this message translates to:
  /// **'Current email'**
  String get profileCurrentEmail;

  /// No description provided for @profileChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get profileChangeEmail;

  /// No description provided for @profileNewEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get profileNewEmailLabel;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get profileEmailInvalid;

  /// No description provided for @profileEmailPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for confirmation of {email}'**
  String profileEmailPending(Object email);

  /// No description provided for @profileEmailChangeRequested.
  ///
  /// In en, this message translates to:
  /// **'Confirmation link sent to {email}. It expires in 24 hours.'**
  String profileEmailChangeRequested(Object email);

  /// No description provided for @profileEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'That email is already registered.'**
  String get profileEmailTaken;

  /// No description provided for @profileEmailChangeInvalid.
  ///
  /// In en, this message translates to:
  /// **'The email change request is invalid or has expired.'**
  String get profileEmailChangeInvalid;

  /// No description provided for @profileSendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get profileSendLink;

  /// No description provided for @profilePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get profilePasswordTitle;

  /// No description provided for @profileCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get profileCurrentPasswordLabel;

  /// No description provided for @profileNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get profileNewPasswordLabel;

  /// No description provided for @profileConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get profileConfirmPasswordLabel;

  /// No description provided for @profileUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get profileUpdatePassword;

  /// No description provided for @profilePasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Other devices were signed out.'**
  String get profilePasswordUpdated;

  /// No description provided for @profilePasswordMin.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get profilePasswordMin;

  /// No description provided for @profilePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get profilePasswordMismatch;

  /// No description provided for @profilePasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect.'**
  String get profilePasswordIncorrect;

  /// No description provided for @profileFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get profileFieldRequired;

  /// No description provided for @profileAvatarTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image is too large (max 2 MB).'**
  String get profileAvatarTooLarge;

  /// No description provided for @profileAvatarInvalidType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported image type. Use PNG, JPG, GIF, or WebP.'**
  String get profileAvatarInvalidType;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @messageActionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get messageActionCopy;

  /// No description provided for @messageActionForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get messageActionForward;

  /// No description provided for @messageActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get messageActionShare;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get messageCopied;

  /// No description provided for @forwardTitle.
  ///
  /// In en, this message translates to:
  /// **'Forward to…'**
  String get forwardTitle;

  /// No description provided for @forwardSent.
  ///
  /// In en, this message translates to:
  /// **'Forwarded to {name}'**
  String forwardSent(Object name);

  /// No description provided for @forwardFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t forward. Please try again.'**
  String get forwardFailed;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share. Please try again.'**
  String get shareFailed;

  /// No description provided for @reactionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the reaction. Please try again.'**
  String get reactionFailed;

  /// No description provided for @messageActionDeleteForMe.
  ///
  /// In en, this message translates to:
  /// **'Delete for me'**
  String get messageActionDeleteForMe;

  /// No description provided for @messageActionDeleteForEveryone.
  ///
  /// In en, this message translates to:
  /// **'Delete for everyone'**
  String get messageActionDeleteForEveryone;

  /// No description provided for @deleteMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete message?'**
  String get deleteMessageTitle;

  /// No description provided for @deleteForMeConfirm.
  ///
  /// In en, this message translates to:
  /// **'This message will be removed from your view only. Other team members will still see it.'**
  String get deleteForMeConfirm;

  /// No description provided for @deleteForEveryoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'This message will be deleted for all team members. The client\'s WhatsApp will keep its copy.'**
  String get deleteForEveryoneConfirm;

  /// No description provided for @deleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirmAction;

  /// No description provided for @deleteMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the message. Please try again.'**
  String get deleteMessageFailed;

  /// No description provided for @messageDeleted.
  ///
  /// In en, this message translates to:
  /// **'This message was deleted'**
  String get messageDeleted;

  /// No description provided for @navReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get navReminders;

  /// No description provided for @remindersOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get remindersOverdue;

  /// No description provided for @remindersToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get remindersToday;

  /// No description provided for @remindersUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get remindersUpcoming;

  /// No description provided for @remindersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get remindersEmptyTitle;

  /// No description provided for @remindersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No open reminders assigned to you. Create them from the portal or the conversation view.'**
  String get remindersEmptyBody;

  /// No description provided for @reminderComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get reminderComplete;

  /// No description provided for @reminderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Reminder completed'**
  String get reminderCompleted;

  /// No description provided for @reminderSnooze15m.
  ///
  /// In en, this message translates to:
  /// **'Snooze 15 minutes'**
  String get reminderSnooze15m;

  /// No description provided for @reminderSnooze1h.
  ///
  /// In en, this message translates to:
  /// **'Snooze 1 hour'**
  String get reminderSnooze1h;

  /// No description provided for @reminderSnooze3h.
  ///
  /// In en, this message translates to:
  /// **'Snooze 3 hours'**
  String get reminderSnooze3h;

  /// No description provided for @reminderSnoozeTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Snooze until tomorrow 9:00'**
  String get reminderSnoozeTomorrow;

  /// No description provided for @reminderSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Reminder snoozed'**
  String get reminderSnoozed;

  /// No description provided for @reminderActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong — please try again'**
  String get reminderActionFailed;

  /// No description provided for @reminderOpenConversation.
  ///
  /// In en, this message translates to:
  /// **'Open conversation'**
  String get reminderOpenConversation;

  /// No description provided for @reminderOverdueLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get reminderOverdueLabel;

  /// No description provided for @reminderActions.
  ///
  /// In en, this message translates to:
  /// **'Reminder actions'**
  String get reminderActions;

  /// No description provided for @clientDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Client details'**
  String get clientDetailTitle;

  /// No description provided for @clientDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this contact. Please try again.'**
  String get clientDetailLoadError;

  /// No description provided for @clientDetailOpenChat.
  ///
  /// In en, this message translates to:
  /// **'Open chat'**
  String get clientDetailOpenChat;

  /// No description provided for @clientDetailJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get clientDetailJoined;

  /// No description provided for @clientDetailLastMessage.
  ///
  /// In en, this message translates to:
  /// **'Last message'**
  String get clientDetailLastMessage;

  /// No description provided for @clientDetailNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get clientDetailNoMessages;

  /// No description provided for @clientDetailContactId.
  ///
  /// In en, this message translates to:
  /// **'Contact ID'**
  String get clientDetailContactId;

  /// No description provided for @clientDetailCopiedId.
  ///
  /// In en, this message translates to:
  /// **'Contact ID copied'**
  String get clientDetailCopiedId;

  /// No description provided for @clientDetailProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get clientDetailProfile;

  /// No description provided for @clientDetailClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clientDetailClear;

  /// No description provided for @clientDetailTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get clientDetailTeam;

  /// No description provided for @clientDetailAssignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get clientDetailAssignee;

  /// No description provided for @clientDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get clientDetailStatus;

  /// No description provided for @clientDetailNoThread.
  ///
  /// In en, this message translates to:
  /// **'No conversation thread yet — nothing to assign.'**
  String get clientDetailNoThread;

  /// No description provided for @clientDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Internal notes'**
  String get clientDetailNotes;

  /// No description provided for @clientDetailNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get clientDetailNoNotes;

  /// No description provided for @clientDetailAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get clientDetailAddNote;

  /// No description provided for @clientDetailDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get clientDetailDeleteNote;

  /// No description provided for @clientDetailSegments.
  ///
  /// In en, this message translates to:
  /// **'Segments'**
  String get clientDetailSegments;

  /// No description provided for @clientDetailNoSegments.
  ///
  /// In en, this message translates to:
  /// **'Not in any segment'**
  String get clientDetailNoSegments;

  /// No description provided for @clientDetailCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get clientDetailCampaigns;

  /// No description provided for @clientDetailNoCampaigns.
  ///
  /// In en, this message translates to:
  /// **'No campaigns yet'**
  String get clientDetailNoCampaigns;

  /// No description provided for @clientDetailUntitledCampaign.
  ///
  /// In en, this message translates to:
  /// **'Untitled campaign'**
  String get clientDetailUntitledCampaign;

  /// No description provided for @clientDetailRecentMessages.
  ///
  /// In en, this message translates to:
  /// **'Recent messages'**
  String get clientDetailRecentMessages;

  /// No description provided for @clientDetailNoRecentMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get clientDetailNoRecentMessages;

  /// No description provided for @clientDetailFromClient.
  ///
  /// In en, this message translates to:
  /// **'From client'**
  String get clientDetailFromClient;

  /// No description provided for @clientDetailFromTeam.
  ///
  /// In en, this message translates to:
  /// **'From team'**
  String get clientDetailFromTeam;

  /// No description provided for @clientDetailViewConversation.
  ///
  /// In en, this message translates to:
  /// **'View conversation'**
  String get clientDetailViewConversation;

  /// No description provided for @clientDetailSuppression.
  ///
  /// In en, this message translates to:
  /// **'Suppression'**
  String get clientDetailSuppression;

  /// No description provided for @clientDetailSuppressionNone.
  ///
  /// In en, this message translates to:
  /// **'Targetable — no active blocks'**
  String get clientDetailSuppressionNone;

  /// No description provided for @clientDetailSuppressedAll.
  ///
  /// In en, this message translates to:
  /// **'All messages blocked'**
  String get clientDetailSuppressedAll;

  /// No description provided for @clientDetailSuppressedMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing blocked'**
  String get clientDetailSuppressedMarketing;

  /// No description provided for @clientDetailRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get clientDetailRelease;

  /// No description provided for @clientDetailReleased.
  ///
  /// In en, this message translates to:
  /// **'Suppression released'**
  String get clientDetailReleased;

  /// No description provided for @clientDetailSuppress.
  ///
  /// In en, this message translates to:
  /// **'Suppress…'**
  String get clientDetailSuppress;

  /// No description provided for @clientDetailSuppressTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppress contact'**
  String get clientDetailSuppressTitle;

  /// No description provided for @clientDetailSuppressScope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get clientDetailSuppressScope;

  /// No description provided for @clientDetailSuppressReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get clientDetailSuppressReason;

  /// No description provided for @clientDetailSuppressed.
  ///
  /// In en, this message translates to:
  /// **'Contact suppressed'**
  String get clientDetailSuppressed;

  /// No description provided for @threadStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get threadStatusOpen;

  /// No description provided for @threadStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get threadStatusPending;

  /// No description provided for @threadStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get threadStatusResolved;

  /// No description provided for @threadStatusSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get threadStatusSnoozed;

  /// No description provided for @statusReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get statusReceived;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderStatusPaid;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @callDirectionIncoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get callDirectionIncoming;

  /// No description provided for @callDirectionOutgoing.
  ///
  /// In en, this message translates to:
  /// **'Outgoing'**
  String get callDirectionOutgoing;

  /// No description provided for @callDirectionMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get callDirectionMissed;

  /// No description provided for @callDirectionRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get callDirectionRejected;

  /// No description provided for @suppressionScopeMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get suppressionScopeMarketing;

  /// No description provided for @suppressionScopeAll.
  ///
  /// In en, this message translates to:
  /// **'All messages'**
  String get suppressionScopeAll;

  /// No description provided for @suppressionReasonUserOptout.
  ///
  /// In en, this message translates to:
  /// **'User opt-out'**
  String get suppressionReasonUserOptout;

  /// No description provided for @suppressionReasonManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get suppressionReasonManual;

  /// No description provided for @suppressionReasonHardBounce.
  ///
  /// In en, this message translates to:
  /// **'Hard bounce'**
  String get suppressionReasonHardBounce;

  /// No description provided for @suppressionReasonBlockedByUser.
  ///
  /// In en, this message translates to:
  /// **'Blocked by user'**
  String get suppressionReasonBlockedByUser;

  /// No description provided for @suppressionReasonCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get suppressionReasonCompliance;
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
