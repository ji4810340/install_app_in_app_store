import 'package:flutter_test/flutter_test.dart';
import 'package:install_app_in_app_store/install_app_in_app_store.dart';
import 'package:install_app_in_app_store/install_app_in_app_store_platform_interface.dart';
import 'package:install_app_in_app_store/install_app_in_app_store_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInstallAppInAppStorePlatform
    with MockPlatformInterfaceMixin
    implements InstallAppInAppStorePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final InstallAppInAppStorePlatform initialPlatform = InstallAppInAppStorePlatform.instance;

  test('$MethodChannelInstallAppInAppStore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInstallAppInAppStore>());
  });

  test('getPlatformVersion', () async {
    InstallAppInAppStore installAppInAppStorePlugin = InstallAppInAppStore();
    MockInstallAppInAppStorePlatform fakePlatform = MockInstallAppInAppStorePlatform();
    InstallAppInAppStorePlatform.instance = fakePlatform;

    expect(await installAppInAppStorePlugin.getPlatformVersion(), '42');
  });
}
