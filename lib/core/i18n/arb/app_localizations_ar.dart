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
  String get navNotifications => 'الإشعارات';

  @override
  String get clientsTitle => 'العملاء';

  @override
  String get searchClients => 'ابحث عن العملاء';

  @override
  String get clientsEmpty => 'لا يوجد عملاء بعد';

  @override
  String get chatsTitle => 'المحادثات';

  @override
  String get chatsEmpty => 'لا توجد محادثات بعد';

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
      'خارج نافذة الـ 24 ساعة. استخدم قالبًا معتمدًا لبدء محادثة جديدة.';

  @override
  String get attachPhoto => 'صورة';

  @override
  String get attachCamera => 'الكاميرا';

  @override
  String get attachDocument => 'مستند';

  @override
  String get sendFailed => 'تعذّر الإرسال. اضغط لإعادة المحاولة.';
}
