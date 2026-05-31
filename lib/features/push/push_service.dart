import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/firebase_options.dart';

import '../../core/providers.dart';
import '../../core/router/app_router.dart';
import '../auth/auth_controller.dart';
import '../chats/chats_controller.dart';
import '../chats/thread_controller.dart';
import '../notifications/notifications_controller.dart';

/// Android notification channel id — must match the backend FCM payload's
/// `android.notification.channel_id` ("messages").
const String kMessagesChannelId = 'messages';

/// Background/terminated handler. Must be a top-level (or static) function
/// annotated for AOT. The system tray renders the `notification` payload
/// automatically; we only ensure Firebase is initialized in this isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // No Firebase config in this build — nothing to do.
  }
}

/// Owns the FCM lifecycle (plan §6): permission, token registration via the
/// existing `DeviceRepo`, foreground/background/tap handling, and deep-linking
/// notification taps into the right chat + tenant.
///
/// Degrades gracefully: if Firebase has no native config (dev), [init] no-ops
/// and the in-app notifications feed still works.
class PushService {
  PushService(this._ref);

  final Ref _ref;
  final _local = FlutterLocalNotificationsPlugin();

  bool _available = false;
  bool _initialized = false;
  String? _registeredToken;

  bool get isAvailable => _available;

  Future<void> init() async {
    if (_initialized) {
      debugPrint('[push] init() skipped — already initialized');
      return;
    }
    _initialized = true;

    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      debugPrint(
        '[push] init() aborted — unsupported platform '
        '(kIsWeb=$kIsWeb, android=${!kIsWeb && Platform.isAndroid}, '
        'ios=${!kIsWeb && Platform.isIOS})',
      );
      return;
    }

    debugPrint('[push] init() — initializing Firebase…');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _available = true;
      debugPrint('[push] Firebase initialized — push available');
    } catch (e) {
      debugPrint('[push] Push disabled — Firebase not configured: $e');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    debugPrint('[push] setting up local notifications…');
    await _setupLocalNotifications();
    debugPrint('[push] local notifications ready');

    // Foreground messages: surface a local notification and refresh data.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    // Tap while backgrounded.
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _routeFromData(m.data));
    // Cold start from a notification tap. Don't await — on iOS this can block
    // until an APNs token arrives (never, on simulator / without APNs config),
    // which would stall the rest of init() incl. the permission request.
    debugPrint('[push] fetching initial message (non-blocking)…');
    FirebaseMessaging.instance.getInitialMessage().then((initial) {
      debugPrint(
        '[push] initial message: ${initial == null ? 'none' : 'present'}',
      );
      if (initial != null) {
        _routeFromData(initial.data);
      }
    });

    // Re-register on token rotation.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _registeredToken = null;
      _registerToken(token);
    });

    // Register whenever the session becomes authenticated.
    _ref.listen<AuthState>(authControllerProvider, (prev, next) {
      debugPrint(
        '[push] auth status changed: ${prev?.status} -> ${next.status}',
      );
      if (next.status == AuthStatus.authenticated) {
        registerForCurrentUser();
      }
    });
    final currentStatus = _ref.read(authControllerProvider).status;
    debugPrint('[push] init() — current auth status: $currentStatus');
    if (currentStatus == AuthStatus.authenticated) {
      await registerForCurrentUser();
    }
  }

  Future<void> _setupLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          final data = (jsonDecode(payload) as Map).cast<String, dynamic>();
          _routeFromData(data);
        } catch (_) {}
      },
    );

    // Android: create the "messages" channel the backend targets.
    final androidImpl = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        kMessagesChannelId,
        'Messages',
        description: 'New WhatsApp messages from your clients',
        importance: Importance.high,
      ),
    );
  }

  /// Request permission, fetch the token, and register it for the current user.
  Future<void> registerForCurrentUser() async {
    debugPrint('[push] registerForCurrentUser() — available=$_available');
    if (!_available) {
      debugPrint('[push] registerForCurrentUser() aborted — push unavailable');
      return;
    }
    debugPrint('[push] requesting notification permission…');
    final settings = await FirebaseMessaging.instance.requestPermission();
    debugPrint('[push] permission result: ${settings.authorizationStatus}');
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // In-app feed still works; nothing to register.
      debugPrint('[push] permission denied — skipping token registration');
      return;
    }

    // iOS requires the APNs token before getToken() will succeed. It arrives
    // asynchronously after registration, so poll briefly rather than reading
    // once. On the simulator (or without a valid APNs key/entitlement) it never
    // arrives — skip rather than throw, so the in-app feed keeps working.
    if (Platform.isIOS) {
      String? apns;
      for (var attempt = 1; attempt <= 5; attempt++) {
        apns = await FirebaseMessaging.instance.getAPNSToken();
        debugPrint(
          '[push] APNs token attempt $attempt/5: '
          '${apns == null ? 'null' : 'acquired'}',
        );
        if (apns != null) break;
        await Future.delayed(const Duration(seconds: 1));
      }
      if (apns == null) {
        debugPrint('[push] no APNs token after retries — skipping FCM token');
        return;
      }
    }

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('[push] FCM token: ${token == null ? 'null' : 'acquired'}');
    if (token != null) await _registerToken(token);
  }

  Future<void> _registerToken(String token) async {
    if (token == _registeredToken) return;
    try {
      await _ref
          .read(deviceRepoProvider)
          .register(
            deviceToken: token,
            platform: Platform.isIOS ? 'ios' : 'android',
            label: await _deviceLabel(),
          );
      _registeredToken = token;
    } catch (e) {
      if (kDebugMode) debugPrint('FCM token registration failed: $e');
    }
  }

  Future<String> _deviceLabel() async {
    final os = Platform.isIOS ? 'ios' : 'android';
    return '$os · 1.0.0';
  }

  /// Called before logout clears the session (while the token is still valid).
  Future<void> deregister() async {
    if (!_available) return;
    try {
      final token =
          _registeredToken ?? await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _ref.read(deviceRepoProvider).deregister(token);
      }
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      if (kDebugMode) debugPrint('FCM deregister failed: $e');
    } finally {
      _registeredToken = null;
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      await _local.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            kMessagesChannelId,
            'Messages',
            channelDescription: 'New WhatsApp messages from your clients',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    }
    _refreshForData(message.data);
  }

  /// Refetch the data a push implies: the chats list, the notifications feed,
  /// and the open thread (if any). Providers are autoDispose, so invalidating
  /// re-runs their fetch.
  void _refreshForData(Map<String, dynamic> data) {
    _ref.invalidate(chatsControllerProvider);
    _ref.invalidate(notificationsControllerProvider);
    final clientId = data['client_id'] as String?;
    if (clientId != null && clientId.isNotEmpty) {
      _ref.invalidate(threadControllerProvider(clientId));
    }
  }

  /// Deep-link a notification tap to the relevant chat, switching tenant first
  /// when the push targets a different workspace the user belongs to.
  void _routeFromData(Map<String, dynamic> data) {
    final clientId = data['client_id'] as String?;
    if (clientId == null || clientId.isEmpty) return;

    final auth = _ref.read(authControllerProvider);
    final targetTenant = data['tenant_id'] as String?;
    if (targetTenant != null &&
        targetTenant.isNotEmpty &&
        targetTenant != auth.activeTenantId &&
        auth.tenants.any((t) => t.id == targetTenant)) {
      _ref.read(authControllerProvider.notifier).selectTenant(targetTenant);
    }

    _ref.read(routerProvider).go('/chats/$clientId');
  }
}

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));
