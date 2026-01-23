import 'package:flutter/material.dart';
import 'dart:async';

import 'package:install_app_in_app_store/install_app_in_app_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _installAppInAppStorePlugin = InstallAppInAppStore();
  int iosAppId = 1234567890;
  String androidPackageName = 'com.example.app';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _installApp() async {
    try {
      final config = AppInstallConfig(
        iosAppId: iosAppId,
        iosAffiliateToken: 'your_affiliate_token',
        iosCampaignToken: 'your_campaign_token',
        androidPackageName: androidPackageName,
      );
      await _installAppInAppStorePlugin.installApp(config);
    } on AppInstallException catch (e) {
      if (!mounted) return;

      errorMessage = e.message;

      if (e.isStoreProductNotAvailable) {
        errorMessage = '该应用在您所在地区不可用';
      } else if (e.isUnknownSkError) {
        errorMessage = '加载失败，请检查网络连接或稍后重试';
      } else if (e.isNetworkError) {
        errorMessage = '网络连接失败，请检查您的网络';
      } else if (e.isInvalidParameter) {
        errorMessage = '配置参数无效';
      } else if (e.isNoRootViewController) {
        errorMessage = '应用界面加载失败';
      }
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('IOS APP on: $iosAppId\n'),
              Text('安卓 APP on: $androidPackageName\n'),
              ElevatedButton(
                onPressed: _installApp,
                child: const Text('Install App'),
              ),
              if (errorMessage?.isNotEmpty == true) Text('错误 on: $errorMessage\n'),
            ],
          ),
        ),
      ),
    );
  }
}
