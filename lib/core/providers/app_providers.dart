import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trialog/core/config/app_config.dart';
import 'package:trialog/shared/services/http_service.dart';
import 'package:trialog/shared/services/storage_service.dart';

/// App configuration provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.current();
});

/// Shared preferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});

/// HTTP service provider
final httpServiceProvider = Provider<HttpService>((ref) {
  final config = ref.watch(appConfigProvider);
  return HttpService(config);
});
