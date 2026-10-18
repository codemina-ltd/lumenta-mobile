import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/providers.dart';
import 'package:mobile/data/models/tenant.dart';
import 'package:mobile/data/models/user.dart';
import 'package:mobile/data/repos/auth_repo.dart';
import 'package:mobile/data/repos/tenant_repo.dart';
import 'package:mobile/data/storage/token_storage.dart';
import 'package:mobile/features/auth/auth_controller.dart';

/// In-memory stand-in for the Keychain-backed [TokenStorage].
class _MemoryTokenStorage extends TokenStorage {
  _MemoryTokenStorage({this.access, this.refresh, this.tenant});
  String? access;
  String? refresh;
  String? tenant;

  @override
  Future<String?> readAccess() async => access;
  @override
  Future<String?> readRefresh() async => refresh;
  @override
  Future<String?> readTenant() async => tenant;
  @override
  Future<void> writeTokens(String a, String r) async {
    access = a;
    refresh = r;
  }

  @override
  Future<void> writeTenant(String tenantId) async => tenant = tenantId;
  @override
  Future<void> clearTenant() async => tenant = null;
  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
    tenant = null;
  }
}

class _FakeAuthRepo extends AuthRepo {
  _FakeAuthRepo() : super(Dio());
  @override
  Future<User> me() async => const User(id: 'u1', email: 'u@x.test');
}

class _FakeTenantRepo extends TenantRepo {
  _FakeTenantRepo(this.tenants) : super(Dio());
  List<TenantSummary> tenants;
  int calls = 0;
  bool fail = false;

  @override
  Future<List<TenantSummary>> listMine() async {
    calls++;
    if (fail) throw DioException(requestOptions: RequestOptions());
    return tenants;
  }
}

const _a = TenantSummary(id: 'a', name: 'Alpha');
const _b = TenantSummary(id: 'b', name: 'Beta');
const _c = TenantSummary(id: 'c', name: 'Gamma');

void main() {
  late _FakeTenantRepo tenantRepo;
  late ProviderContainer container;

  /// Boots a signed-in, two-workspace user already inside workspace `a`.
  Future<AuthController> boot() async {
    tenantRepo = _FakeTenantRepo([_a, _b]);
    container = ProviderContainer(
      overrides: [
        tokenStorageProvider.overrideWithValue(
          _MemoryTokenStorage(access: 'at', refresh: 'rt', tenant: 'a'),
        ),
        authRepoProvider.overrideWithValue(_FakeAuthRepo()),
        tenantRepoProvider.overrideWithValue(tenantRepo),
      ],
    );
    addTearDown(container.dispose);
    final ctrl = container.read(authControllerProvider.notifier);
    await ctrl.bootstrap();
    expect(
      container.read(authControllerProvider).status,
      AuthStatus.authenticated,
    );
    expect(container.read(authControllerProvider).activeTenantId, 'a');
    return ctrl;
  }

  group('switchTenant', () {
    test('moves to needsTenant so the router shows the picker', () async {
      final ctrl = await boot();
      await ctrl.switchTenant();
      final s = container.read(authControllerProvider);
      expect(s.status, AuthStatus.needsTenant);
      // The current workspace stays known (picker can offer "back") and the
      // persisted selection is untouched for the next cold start.
      expect(s.activeTenantId, 'a');
      expect(s.tenants.map((t) => t.id), ['a', 'b']);
      expect(container.read(authSessionProvider).activeTenantId, 'a');
    });

    test('refreshes the tenant list, keeping the cache when offline', () async {
      final ctrl = await boot();
      tenantRepo.tenants = [_a, _b, _c];
      await ctrl.switchTenant();
      expect(container.read(authControllerProvider).tenants.length, 3);

      // Back in, then switch again while the list call fails.
      expect(await ctrl.selectTenant('a'), isTrue);
      tenantRepo.fail = true;
      await ctrl.switchTenant();
      final s = container.read(authControllerProvider);
      expect(s.status, AuthStatus.needsTenant);
      expect(s.tenants.length, 3);
    });

    test('is a no-op unless authenticated', () async {
      final ctrl = await boot();
      await ctrl.switchTenant();
      final before = tenantRepo.calls;
      await ctrl.switchTenant();
      expect(tenantRepo.calls, before);
      expect(
        container.read(authControllerProvider).status,
        AuthStatus.needsTenant,
      );
    });

    test('picking another workspace enters it', () async {
      final ctrl = await boot();
      await ctrl.switchTenant();
      expect(await ctrl.selectTenant('b'), isTrue);
      final s = container.read(authControllerProvider);
      expect(s.status, AuthStatus.authenticated);
      expect(s.activeTenantId, 'b');
      expect(container.read(authSessionProvider).activeTenantId, 'b');
    });
  });

  group('cancelSwitchTenant', () {
    test('returns to the current workspace without re-selecting', () async {
      final ctrl = await boot();
      await ctrl.switchTenant();
      ctrl.cancelSwitchTenant();
      final s = container.read(authControllerProvider);
      expect(s.status, AuthStatus.authenticated);
      expect(s.activeTenantId, 'a');
    });

    test('stays on the picker when the current workspace is no longer '
        'enterable', () async {
      final ctrl = await boot();
      // Mobile login got switched off for `a` while the user was inside.
      tenantRepo.tenants = [
        const TenantSummary(id: 'a', name: 'Alpha', mobileLoginEnabled: false),
        _b,
      ];
      await ctrl.switchTenant();
      ctrl.cancelSwitchTenant();
      expect(
        container.read(authControllerProvider).status,
        AuthStatus.needsTenant,
      );
    });
  });
}
