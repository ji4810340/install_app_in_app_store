import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:install_app_in_app_store/install_app_in_app_store_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelInstallAppInAppStore platform = MethodChannelInstallAppInAppStore();
  const MethodChannel channel = MethodChannel('install_app_in_app_store');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
