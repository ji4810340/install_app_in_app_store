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
    final config = AppInstallConfig(
      iosAppId: iosAppId,
      iosAffiliateToken: 'your_affiliate_token',
      iosCampaignToken: 'your_campaign_token',
      androidPackageName: androidPackageName,
    );

    await _installAppInAppStorePlugin.installApp(
      config,
      onSuccess: () {
        if (!mounted) return;
        setState(() {
          errorMessage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('应用安装页面已打开')),
        );
      },
      onError: (exception) {
        if (!mounted) return;

        String message = exception.message;

        if (exception.isStoreProductNotAvailable) {
          message = '该应用在您所在地区不可用';
        } else if (exception.isUnknownSkError) {
          message = '加载失败，请检查网络连接或稍后重试';
        } else if (exception.isNetworkError) {
          message = '网络连接失败，请检查您的网络';
        } else if (exception.isInvalidParameter) {
          message = '配置参数无效';
        } else if (exception.isNoRootViewController) {
          message = '应用界面加载失败';
        }

        setState(() {
          errorMessage = message;
        });
      },
    );
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
              if (errorMessage?.isNotEmpty == true)
                Text('错误 on: $errorMessage\n'),
            ],
          ),
        ),
      ),
    );
  }
}
