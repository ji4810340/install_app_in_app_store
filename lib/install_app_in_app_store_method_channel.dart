import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'install_app_in_app_store_platform_interface.dart';

/// An implementation of [InstallAppInAppStorePlatform] that uses method channels.
class MethodChannelInstallAppInAppStore extends InstallAppInAppStorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('install_app_in_app_store');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
