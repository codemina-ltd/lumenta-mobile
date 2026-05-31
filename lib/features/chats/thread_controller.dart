import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/message.dart';
import '../../data/models/template.dart';
import '../templates/template_vars.dart';
import 'chats_controller.dart';

@immutable
class ThreadState {
  const ThreadState({
    this.messages = const [],
    this.loading = true,
    this.loadingOlder = false,
    this.error,
    this.page = 0,
    this.hasOlder = true,
  });

  /// Sorted ascending by createdAt (oldest first → newest at the bottom).
  final List<Message> messages;
  final bool loading;
  final bool loadingOlder;
  final Object? error;
  final int page;
  final bool hasOlder;

  ThreadState copyWith({
    List<Message>? messages,
    bool? loading,
    bool? loadingOlder,
    Object? error,
    bool clearError = false,
    int? page,
    bool? hasOlder,
  }) => ThreadState(
    messages: messages ?? this.messages,
    loading: loading ?? this.loading,
    loadingOlder: loadingOlder ?? this.loadingOlder,
    error: clearError ? null : (error ?? this.error),
    page: page ?? this.page,
    hasOlder: hasOlder ?? this.hasOlder,
  );
}

class ThreadController extends StateNotifier<ThreadState> {
  ThreadController(this._ref, this.clientId) : super(const ThreadState()) {
    refresh();
  }

  final Ref _ref;
  final String clientId;

  final Map<String, Message> _byId = {};

  Future<void> refresh() async {
    _byId.clear();
    state = state.copyWith(loading: true, clearError: true);
    await _loadPage(1);
  }

  Future<void> loadOlder() async {
    if (state.loadingOlder || !state.hasOlder || state.loading) return;
    state = state.copyWith(loadingOlder: true);
    await _loadPage(state.page + 1);
  }

  Future<void> _loadPage(int page) async {
    try {
      final result =
          await _ref.read(messagesRepoProvider).thread(clientId, page: page);
      for (final m in result.data) {
        _byId[m.id] = m;
      }
      final sorted = _byId.values.toList()
        ..sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));
      state = state.copyWith(
        messages: sorted,
        loading: false,
        loadingOlder: false,
        page: result.page,
        hasOlder: result.hasMore,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, loadingOlder: false, error: e);
    }
  }

  /// Newest message timestamp, for the local last-read cursor.
  DateTime? get newestTimestamp =>
      state.messages.isEmpty ? null : state.messages.last.createdAtDate;

  /// Send a free-form text reply with an optimistic bubble.
  Future<void> sendText(String to, String body) async {
    final temp = _optimistic(body: body, type: MessageType.text);
    _insert(temp);
    try {
      final sent =
          await _ref.read(messagesRepoProvider).sendText(to: to, body: body);
      _replace(temp.id, sent);
    } catch (_) {
      _markFailed(temp.id);
    }
  }

  /// Send an approved template with an optimistic bubble. Unlike free-text,
  /// this works regardless of the 24h service window. Returns the failure (if
  /// any) so the UI can surface the provider error (e.g. Meta code 131049).
  Future<Object?> sendTemplate({
    required String to,
    required Template template,
    required Map<String, String> variables,
    Map<String, String>? buttonVariables,
  }) async {
    final temp = _optimistic(
      body: renderPreview(template, variables),
      type: MessageType.text,
    );
    _insert(temp);
    try {
      final sent = await _ref.read(messagesRepoProvider).sendTemplate(
            to: to,
            templateId: template.id,
            templateVariables: variables,
            buttonVariables: buttonVariables,
          );
      _replace(temp.id, sent);
      // Bump the conversation to the top of the chats list.
      _ref.read(chatsControllerProvider.notifier).refresh();
      return null;
    } catch (e) {
      _markFailed(temp.id);
      return e;
    }
  }

  /// Send a media reply with an optimistic bubble.
  Future<void> sendMedia({
    required String to,
    required String mediaType,
    required String filePath,
    String? caption,
    String? filename,
  }) async {
    final type = _typeFromMedia(mediaType);
    final temp = _optimistic(body: caption ?? '', type: type);
    _insert(temp);
    try {
      final sent = await _ref.read(messagesRepoProvider).sendMedia(
            to: to,
            mediaType: mediaType,
            filePath: filePath,
            caption: caption,
            filename: filename,
          );
      _replace(temp.id, sent);
    } catch (_) {
      _markFailed(temp.id);
    }
  }

  Message _optimistic({required String body, required MessageType type}) {
    final id = 'temp_${DateTime.now().microsecondsSinceEpoch}';
    return Message(
      id: id,
      direction: MessageDirection.outbound,
      body: body,
      status: MessageStatus.sent,
      messageType: type,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

  MessageType _typeFromMedia(String mediaType) {
    switch (mediaType) {
      case 'image':
        return MessageType.image;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      default:
        return MessageType.document;
    }
  }

  void _insert(Message m) {
    _byId[m.id] = m;
    _resort();
  }

  void _replace(String tempId, Message real) {
    _byId.remove(tempId);
    _byId[real.id] = real;
    _resort();
  }

  void _markFailed(String tempId) {
    final m = _byId[tempId];
    if (m != null) {
      _byId[tempId] = m.copyWith(status: MessageStatus.failed);
      _resort();
    }
  }

  void _resort() {
    final sorted = _byId.values.toList()
      ..sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));
    state = state.copyWith(messages: sorted);
  }
}

final threadControllerProvider = StateNotifierProvider.autoDispose
    .family<ThreadController, ThreadState, String>((ref, clientId) {
  return ThreadController(ref, clientId);
});
