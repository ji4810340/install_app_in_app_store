import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'install_app_in_app_store_method_channel.dart';

abstract class InstallAppInAppStorePlatform extends PlatformInterface {
  /// Constructs a InstallAppInAppStorePlatform.
  InstallAppInAppStorePlatform() : super(token: _token);

  static final Object _token = Object();

  static InstallAppInAppStorePlatform _instance = MethodChannelInstallAppInAppStore();

  /// The default instance of [InstallAppInAppStorePlatform] to use.
  ///
  /// Defaults to [MethodChannelInstallAppInAppStore].
  static InstallAppInAppStorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InstallAppInAppStorePlatform] when
  /// they register themselves.
  static set instance(InstallAppInAppStorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
