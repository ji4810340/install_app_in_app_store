import 'install_app_in_app_store_platform_interface.dart';
export 'generated/app_install_api.dart';

import 'generated/app_install_api.dart';
import 'package:flutter/services.dart';

class InstallAppInAppStore {
  Future<String?> getPlatformVersion() {
    return InstallAppInAppStorePlatform.instance.getPlatformVersion();
  }

  Future<void> installApp(
    AppInstallConfig config, {
    VoidCallback? onSuccess,
    Function(AppInstallException)? onError,
  }) async {
    final api = AppInstallApi();
    try {
      await api.installApp(config);
      onSuccess?.call();
    } on PlatformException catch (e) {
      final exception = AppInstallException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
      onError?.call(exception);
      throw exception;
    }
  }
}

class AppInstallException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  AppInstallException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'AppInstallException($code): $message';

  bool get isStoreProductNotAvailable => code == 'STORE_PRODUCT_NOT_AVAILABLE';

  bool get isUnknownSkError => code == 'UNKNOWN_SK_ERROR';

  bool get isNetworkError => code == 'NETWORK_ERROR';

  bool get isInvalidParameter => code == 'INVALID_PARAMETER';

  bool get isNoRootViewController => code == 'NO_ROOT_VIEW_CONTROLLER';
}
