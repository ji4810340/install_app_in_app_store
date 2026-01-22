import 'install_app_in_app_store_platform_interface.dart';
export 'generated/app_install_api.dart';

import 'generated/app_install_api.dart';

class InstallAppInAppStore {
  Future<String?> getPlatformVersion() {
    return InstallAppInAppStorePlatform.instance.getPlatformVersion();
  }

  Future<void> installApp(AppInstallConfig config) {
    final api = AppInstallApi();
    return api.installApp(config);
  }
}
