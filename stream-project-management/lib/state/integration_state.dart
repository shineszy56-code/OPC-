import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/integration_service.dart';

/// 集成服务提供者
final integrationServiceProvider = Provider<IntegrationService>((ref) {
  return IntegrationService();
});

/// 集成状态提供者
final integrationStatusProvider = FutureProvider<IntegrationStatus>((
  ref,
) async {
  final service = ref.watch(integrationServiceProvider);
  return service.getStatus();
});
