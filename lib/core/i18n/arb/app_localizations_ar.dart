// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لومينتا';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'مرحبًا بعودتك إلى لومينتا';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get loginError =>
      'تعذّر تسجيل الدخول. تحقق من بياناتك وحاول مرة أخرى.';

  @override
  String get tenantPickerTitle => 'اختر مساحة عمل';

  @override
  String get switchTenant => 'تبديل مساحة العمل';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get navClients => 'العملاء';

  @override
  String get navChats => 'المحادثات';

  @override
  String get navInbox => 'الصندوق';

  @override
  String get navNotifications => 'الإشعارات';

  @override
  String get inboxViewMine => 'الخاصة بي';

  @override
  String get inboxViewUnassigned => 'غير مُسندة';

  @override
  String get inboxViewOpen => 'مفتوحة';

  @override
  String get inboxViewSnoozed => 'مؤجلة';

  @override
  String get inboxViewAll => 'الكل';

  @override
  String get inboxEmpty => 'لا توجد محادثات تطابق هذا العرض';

  @override
  String get inboxAssignToMe => 'أسندها لي';

  @override
  String get inboxStatusResolved => 'وضع تم الحل';

  @override
  String get inboxStatusPending => 'وضع قيد الانتظار';

  @override
  String get inboxAddNote => 'إضافة ملاحظة داخلية';

  @override
  String get inboxNoteHint => 'ملاحظة داخلية — لن يراها العميل';

  @override
  String get inboxMentionHint => 'اكتب @ لذكر زميل';

  @override
  String get inboxMentionNotFound => 'لا يوجد زملاء مطابقون';

  @override
  String get inboxActionFailed => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get inboxCancel => 'إلغاء';

  @override
  String get inboxSave => 'حفظ';

  @override
  String get inboxReopen => 'إعادة فتح';

  @override
  String get inboxAssignToMember => 'إسناد إلى عضو…';

  @override
  String get inboxUnassign => 'إلغاء الإسناد';

  @override
  String get inboxSnoozeUntil => 'تأجيل حتى…';

  @override
  String get inboxPriority => 'الأولوية';

  @override
  String get inboxPriorityLow => 'منخفضة';

  @override
  String get inboxPriorityNormal => 'عادية';

  @override
  String get inboxPriorityHigh => 'مرتفعة';

  @override
  String get inboxLabels => 'الوسوم';

  @override
  String get inboxNoLabels => 'لا توجد وسوم بعد';

  @override
  String get inboxAssigneeUnassigned => 'غير مُسندة';

  @override
  String get contactDetails => 'تفاصيل العميل';

  @override
  String get contactLifecycle => 'مرحلة دورة الحياة';

  @override
  String get contactNoStage => 'بدون مرحلة';

  @override
  String get contactOptIn => 'الموافقة على التسويق';

  @override
  String get contactFields => 'الحقول المخصصة';

  @override
  String get contactNoFields => 'لا توجد حقول مخصصة';

  @override
  String get contactLoadError => 'تعذّر تحميل تفاصيل العميل.';

  @override
  String get contactSaveFailed => 'تعذّر الحفظ. حاول مرة أخرى.';

  @override
  String get contactCameFrom => 'أتى من:';

  @override
  String get ordersTitle => 'الطلبات';

  @override
  String get ordersEmpty => 'لا توجد طلبات لهذا العميل';

  @override
  String get ordersActionFailed => 'تعذّر التحديث. حاول مرة أخرى.';

  @override
  String get clientsTitle => 'العملاء';

  @override
  String get searchClients => 'ابحث عن العملاء';

  @override
  String get searchGlobalTitle => 'البحث';

  @override
  String get searchGlobalHint => 'ابحث عن العملاء والرسائل والملاحظات…';

  @override
  String get searchMinChars =>
      'اكتب حرفين على الأقل للبحث في العملاء والرسائل والملاحظات والمزيد';

  @override
  String searchNoResults(Object query) {
    return 'لا توجد نتائج لـ «$query»';
  }

  @override
  String get searchSourceCustomField => 'حقل مخصص';

  @override
  String get searchSourceMessage => 'رسالة';

  @override
  String get searchSourceNote => 'ملاحظة';

  @override
  String get searchSourceHeadline => 'عنوان الإعلان';

  @override
  String get clientsEmpty => 'لا يوجد عملاء بعد';

  @override
  String get chatsTitle => 'المحادثات';

  @override
  String get chatsEmpty => 'لا توجد محادثات بعد';

  @override
  String get chatAssign => 'إسناد إلى عضو في الفريق';

  @override
  String get chatNoteAdded => 'تمت إضافة الملاحظة الداخلية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsEmpty => 'لقد اطّلعت على كل شيء';

  @override
  String get markAllRead => 'تعليم الكل كمقروء';

  @override
  String get previewPhoto => 'صورة';

  @override
  String get previewVoice => 'رسالة صوتية';

  @override
  String get previewAudio => 'صوت';

  @override
  String get previewVideo => 'فيديو';

  @override
  String get previewDocument => 'مستند';

  @override
  String get previewLocation => 'موقع';

  @override
  String get previewSticker => 'ملصق';

  @override
  String get previewContact => 'جهة اتصال';

  @override
  String get flowResponseTitle => 'رد تفاعلي';

  @override
  String get flowResponseReceived => 'تم استلام الرد';

  @override
  String get flowResponseDetailsTitle => 'رد العميل';

  @override
  String get flowFieldColumn => 'الحقل';

  @override
  String get flowValueColumn => 'القيمة';

  @override
  String get close => 'إغلاق';

  @override
  String get statusSent => 'تم الإرسال';

  @override
  String get statusDelivered => 'تم التسليم';

  @override
  String get statusRead => 'تمت القراءة';

  @override
  String get statusFailed => 'فشل';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loadingError => 'حدث خطأ ما';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get transcription => 'النص المكتوب';

  @override
  String get openDocument => 'فتح المستند';

  @override
  String get loginNoRecaptcha =>
      'تسجيل الدخول غير مهيأ (مفتاح reCAPTCHA مفقود).';

  @override
  String get composerHint => 'رسالة';

  @override
  String get windowClosed =>
      'خارج نافذة الـ 24 ساعة. أرسِل قالبًا معتمدًا لبدء محادثة جديدة.';

  @override
  String get attachPhoto => 'صورة';

  @override
  String get attachCamera => 'الكاميرا';

  @override
  String get attachDocument => 'مستند';

  @override
  String get sendFailed => 'تعذّر الإرسال. اضغط لإعادة المحاولة.';

  @override
  String get senderStartVia => 'بدء محادثة عبر…';

  @override
  String get senderDefaultTag => 'افتراضي';

  @override
  String get senderInactive => 'هذا الرقم غير نشط';

  @override
  String get senderInactiveComposer => 'هذا الرقم غير نشط — الإرسال معطّل';

  @override
  String get senderNoHistory =>
      'لا توجد رسائل عبر هذا الرقم بعد. أرسل رسالة لبدء المحادثة.';

  @override
  String sendingAs(Object name, Object number) {
    return 'الإرسال باسم $name · $number';
  }

  @override
  String sendingAsNameOnly(Object name) {
    return 'الإرسال باسم $name';
  }

  @override
  String get sendTemplate => 'إرسال قالب';

  @override
  String get attachTemplate => 'قالب';

  @override
  String get templatePickerTitle => 'اختر قالبًا';

  @override
  String get templateSearchHint => 'ابحث عن القوالب';

  @override
  String get noApprovedTemplates => 'لا توجد قوالب معتمدة';

  @override
  String get noApprovedTemplatesHint =>
      'أنشئ القوالب من بوابة لومينتا على الويب.';

  @override
  String get templateFillTitle => 'املأ بيانات القالب';

  @override
  String get templatePreview => 'معاينة';

  @override
  String templateVarRequired(Object names) {
    return 'يرجى ملء: $names';
  }

  @override
  String get templateSendFailed => 'تعذّر إرسال القالب. حاول مرة أخرى.';

  @override
  String get templateImageHeader => 'صورة';

  @override
  String get templateSeeAllOptions => 'عرض كل الخيارات';

  @override
  String get templateAllOptionsTitle => 'كل الخيارات';

  @override
  String get templateVideoHeader => 'فيديو';

  @override
  String get templateDocHeader => 'مستند';

  @override
  String get templateMarketingUsWarning =>
      'قد تحظر Meta القوالب التسويقية المرسلة إلى أرقام أمريكية.';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profilePictureTitle => 'الصورة الشخصية';

  @override
  String get profileUploadPicture => 'رفع صورة';

  @override
  String get profileRemovePicture => 'إزالة';

  @override
  String get profileIdentityTitle => 'الهوية';

  @override
  String get profileFullNameLabel => 'الاسم الكامل';

  @override
  String get profileNameTooShort => 'أدخل حرفين على الأقل';

  @override
  String get profilePhoneLabel => 'رقم الهاتف';

  @override
  String get profilePhoneHelper =>
      'بالتنسيق الدولي، أرقام فقط (رمز الدولة، بدون علامة +).';

  @override
  String get profilePhoneInvalid =>
      'أرقام فقط: رمز الدولة + الرقم (7–15 رقمًا)';

  @override
  String get profileLanguageLabel => 'اللغة';

  @override
  String get profileTimezoneLabel => 'المنطقة الزمنية';

  @override
  String get profileTimezoneSearchHint => 'ابحث عن منطقة زمنية';

  @override
  String get profileSaveChanges => 'حفظ التغييرات';

  @override
  String get profileSaved => 'تم تحديث الملف الشخصي';

  @override
  String get profileSaveFailed => 'تعذّر الحفظ. حاول مرة أخرى.';

  @override
  String get profileAppearanceTitle => 'المظهر';

  @override
  String get profileFontLabel => 'خط العرض';

  @override
  String get profileFontHelper => 'يُستخدم في البوابة للإنجليزية والفرنسية.';

  @override
  String get profileSaveFont => 'حفظ الخط';

  @override
  String get profileFontSaved => 'تم تحديث الخط';

  @override
  String get profileEmailTitle => 'البريد الإلكتروني';

  @override
  String get profileCurrentEmail => 'البريد الحالي';

  @override
  String get profileChangeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get profileNewEmailLabel => 'البريد الإلكتروني الجديد';

  @override
  String get profileEmailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String profileEmailPending(Object email) {
    return 'بانتظار تأكيد $email';
  }

  @override
  String profileEmailChangeRequested(Object email) {
    return 'أُرسل رابط التأكيد إلى $email. تنتهي صلاحيته خلال 24 ساعة.';
  }

  @override
  String get profileEmailTaken => 'هذا البريد الإلكتروني مسجّل بالفعل.';

  @override
  String get profileEmailChangeInvalid =>
      'طلب تغيير البريد غير صالح أو انتهت صلاحيته.';

  @override
  String get profileSendLink => 'إرسال الرابط';

  @override
  String get profilePasswordTitle => 'كلمة المرور';

  @override
  String get profileCurrentPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get profileNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get profileConfirmPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get profileUpdatePassword => 'تحديث كلمة المرور';

  @override
  String get profilePasswordUpdated =>
      'تم تحديث كلمة المرور. تم تسجيل الخروج من الأجهزة الأخرى.';

  @override
  String get profilePasswordMin => '8 أحرف على الأقل';

  @override
  String get profilePasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get profilePasswordIncorrect => 'كلمة المرور الحالية غير صحيحة.';

  @override
  String get profileFieldRequired => 'مطلوب';

  @override
  String get profileAvatarTooLarge =>
      'الصورة كبيرة جدًا (الحد الأقصى 2 ميغابايت).';

  @override
  String get profileAvatarInvalidType =>
      'نوع الصورة غير مدعوم. استخدم PNG أو JPG أو GIF أو WebP.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get messageActionCopy => 'نسخ';

  @override
  String get messageActionForward => 'إعادة توجيه';

  @override
  String get messageActionShare => 'مشاركة';

  @override
  String get messageCopied => 'تم النسخ إلى الحافظة';

  @override
  String get forwardTitle => 'إعادة التوجيه إلى…';

  @override
  String forwardSent(Object name) {
    return 'تمت إعادة التوجيه إلى $name';
  }

  @override
  String get forwardFailed => 'تعذّرت إعادة التوجيه. حاول مرة أخرى.';

  @override
  String get shareFailed => 'تعذّرت المشاركة. حاول مرة أخرى.';

  @override
  String get reactionFailed => 'تعذّر إرسال التفاعل. حاول مرة أخرى.';

  @override
  String get messageActionDeleteForMe => 'حذف لديّ';

  @override
  String get messageActionDeleteForEveryone => 'حذف لدى الجميع';

  @override
  String get deleteMessageTitle => 'حذف الرسالة؟';

  @override
  String get deleteForMeConfirm =>
      'ستتم إزالة هذه الرسالة من عرضك فقط، وسيظل بإمكان بقية أعضاء الفريق رؤيتها.';

  @override
  String get deleteForEveryoneConfirm =>
      'سيتم حذف هذه الرسالة لجميع أعضاء الفريق، وستبقى نسخة العميل في واتساب كما هي.';

  @override
  String get deleteConfirmAction => 'حذف';

  @override
  String get deleteMessageFailed => 'تعذّر حذف الرسالة. حاول مرة أخرى.';

  @override
  String get messageDeleted => 'تم حذف هذه الرسالة';

  @override
  String get navReminders => 'التذكيرات';

  @override
  String get remindersOverdue => 'متأخرة';

  @override
  String get remindersToday => 'مستحقة اليوم';

  @override
  String get remindersUpcoming => 'قادمة';

  @override
  String get remindersEmptyTitle => 'كل شيء تحت السيطرة';

  @override
  String get remindersEmptyBody =>
      'لا توجد تذكيرات مفتوحة مسندة إليك. يمكنك إنشاؤها من البوابة أو من شاشة المحادثة.';

  @override
  String get reminderComplete => 'وضع علامة تم';

  @override
  String get reminderCompleted => 'اكتمل التذكير';

  @override
  String get reminderSnooze15m => 'تأجيل 15 دقيقة';

  @override
  String get reminderSnooze1h => 'تأجيل ساعة';

  @override
  String get reminderSnooze3h => 'تأجيل 3 ساعات';

  @override
  String get reminderSnoozeTomorrow => 'تأجيل حتى الغد 9:00';

  @override
  String get reminderSnoozed => 'تم تأجيل التذكير';

  @override
  String get reminderActionFailed => 'حدث خطأ ما — حاول مرة أخرى';

  @override
  String get reminderOpenConversation => 'فتح المحادثة';

  @override
  String get reminderOverdueLabel => 'متأخر';

  @override
  String get reminderActions => 'إجراءات التذكير';

  @override
  String get clientDetailTitle => 'تفاصيل العميل';

  @override
  String get clientDetailLoadError => 'تعذّر تحميل جهة الاتصال. حاول مرة أخرى.';

  @override
  String get clientDetailOpenChat => 'فتح المحادثة';

  @override
  String get clientDetailJoined => 'انضمّ';

  @override
  String get clientDetailLastMessage => 'آخر رسالة';

  @override
  String get clientDetailNoMessages => 'لا توجد رسائل بعد';

  @override
  String get clientDetailContactId => 'معرّف جهة الاتصال';

  @override
  String get clientDetailCopiedId => 'تم نسخ معرّف جهة الاتصال';

  @override
  String get clientDetailProfile => 'الملف التعريفي';

  @override
  String get clientDetailTeam => 'الفريق';

  @override
  String get clientDetailAssignee => 'المسؤول';

  @override
  String get clientDetailStatus => 'الحالة';

  @override
  String get clientDetailNoThread => 'لا توجد محادثة بعد — لا شيء لإسناده.';

  @override
  String get clientDetailNotes => 'الملاحظات الداخلية';

  @override
  String get clientDetailNoNotes => 'لا توجد ملاحظات بعد';

  @override
  String get clientDetailAddNote => 'إضافة ملاحظة';

  @override
  String get clientDetailDeleteNote => 'حذف الملاحظة';

  @override
  String get clientDetailSegments => 'الشرائح';

  @override
  String get clientDetailNoSegments => 'ليس ضمن أي شريحة';

  @override
  String get clientDetailCampaigns => 'الحملات';

  @override
  String get clientDetailNoCampaigns => 'لا توجد حملات بعد';

  @override
  String get clientDetailUntitledCampaign => 'حملة بدون عنوان';

  @override
  String get clientDetailRecentMessages => 'أحدث الرسائل';

  @override
  String get clientDetailNoRecentMessages => 'لا توجد رسائل بعد';

  @override
  String get clientDetailFromClient => 'من العميل';

  @override
  String get clientDetailFromTeam => 'من الفريق';

  @override
  String get clientDetailViewConversation => 'عرض المحادثة';

  @override
  String get clientDetailSuppression => 'الحظر';

  @override
  String get clientDetailSuppressionNone =>
      'قابل للاستهداف — لا توجد قيود نشطة';

  @override
  String get clientDetailSuppressedAll => 'جميع الرسائل محظورة';

  @override
  String get clientDetailSuppressedMarketing => 'الرسائل التسويقية محظورة';

  @override
  String get clientDetailRelease => 'إلغاء الحظر';

  @override
  String get clientDetailReleased => 'تم إلغاء الحظر';

  @override
  String get clientDetailSuppress => 'حظر…';

  @override
  String get clientDetailSuppressTitle => 'حظر جهة الاتصال';

  @override
  String get clientDetailSuppressScope => 'النطاق';

  @override
  String get clientDetailSuppressReason => 'السبب';

  @override
  String get clientDetailSuppressed => 'تم حظر جهة الاتصال';

  @override
  String get threadStatusOpen => 'مفتوحة';

  @override
  String get threadStatusPending => 'قيد الانتظار';

  @override
  String get threadStatusResolved => 'تم الحل';

  @override
  String get threadStatusSnoozed => 'مؤجلة';

  @override
  String get statusReceived => 'مستلمة';

  @override
  String get orderStatusPending => 'قيد الانتظار';

  @override
  String get orderStatusConfirmed => 'مؤكد';

  @override
  String get orderStatusPaid => 'مدفوع';

  @override
  String get orderStatusShipped => 'تم الشحن';

  @override
  String get orderStatusCompleted => 'مكتمل';

  @override
  String get orderStatusCancelled => 'ملغى';

  @override
  String get suppressionScopeMarketing => 'تسويقي';

  @override
  String get suppressionScopeAll => 'جميع الرسائل';

  @override
  String get suppressionReasonUserOptout => 'إلغاء اشتراك المستخدم';

  @override
  String get suppressionReasonManual => 'يدوي';

  @override
  String get suppressionReasonHardBounce => 'ارتداد دائم';

  @override
  String get suppressionReasonBlockedByUser => 'حظره المستخدم';

  @override
  String get suppressionReasonCompliance => 'الامتثال';
}
