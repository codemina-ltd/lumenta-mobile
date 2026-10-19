import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../clients/clients_controller.dart';

/// Client list behind the "New chat" sheet. Same controller as the Clients
/// page but a separate provider instance, so typing in the sheet never
/// disturbs the Clients page's own search/pagination (both can be alive at
/// once). autoDispose: it resets when the sheet closes.
final newChatClientsProvider =
    NotifierProvider.autoDispose<ClientsController, ClientsState>(
      ClientsController.new,
    );
