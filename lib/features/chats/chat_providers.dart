import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/client.dart';

/// Single client for the chat header (cached per client id).
final clientProvider =
    FutureProvider.autoDispose.family<Client, String>((ref, id) async {
  return ref.read(clientsRepoProvider).getById(id);
});

/// Auth headers for loading proxied media (`/messages/:id/media`).
final mediaHeadersProvider = Provider<Map<String, String>>((ref) {
  final session = ref.watch(authSessionProvider);
  return {
    if (session.accessToken != null)
      'Authorization': 'Bearer ${session.accessToken}',
    if (session.activeTenantId != null)
      'X-Tenant-Id': session.activeTenantId!,
  };
});

/// Downloads proxied media bytes through the authenticated Dio (for audio).
final mediaBytesLoaderProvider =
    Provider<Future<Uint8List?> Function(String url)>((ref) {
  final dio = ref.watch(dioProvider);
  return (url) async {
    try {
      final res = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final data = res.data;
      return data == null ? null : Uint8List.fromList(data);
    } on DioException {
      return null;
    }
  };
});
