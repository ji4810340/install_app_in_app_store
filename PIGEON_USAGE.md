# Pigeon API 使用指南

本项目使用 Pigeon 来定义 Flutter 和原生代码之间的桥接方法。

## 项目结构

- `pigeons/app_install_api.dart` - Pigeon 定义文件
- `lib/generated/app_install_api.dart` - 生成的 Dart 代码
- `ios/Classes/GeneratedAppInstallApi.swift` - 生成的 Swift 代码
- `ios/Classes/InstallAppInAppStorePlugin.swift` - iOS 插件实现

## 使用方法

### 1. 在 Dart 中调用原生方法

```dart
import 'package:install_app_in_app_store/install_app_in_app_store.dart';

final plugin = InstallAppInAppStore();

// 创建配置对象
final config = AppInstallConfig(
  iosAppId: 1234567890,
  iosIapId: 'com.example.iap',
  iosAffiliateToken: 'your_affiliate_token',
  iosCampaignToken: 'your_campaign_token',
  iosAdvertisingPartnerToken: 'your_partner_token',
  iosProviderToken: 'your_provider_token',
  androidPackageName: 'com.example.app',
);

// 调用安装方法
try {
  await plugin.installApp(config);
} catch (e) {
  print('Error: $e');
}
```

### 2. iOS 原生实现

iOS 插件已经实现了 `AppInstallApi` 协议，使用 `SKStoreProductViewController` 来显示 App Store 产品页面。

主要功能：
- 支持 iOS App ID
- 支持 IAP 产品标识符
- 支持 Affiliate Token
- 支持 Campaign Token
- 支持 Advertising Partner Token
- 支持 Provider Token
- 自动处理视图控制器的呈现

### 3. Android 原生实现

Android 插件已经实现了 `AppInstallApi` 接口，使用 Intent 打开 Google Play Store。

主要功能：
- 支持 Android 包名
- 自动打开 Google Play Store 应用详情页面
- 错误处理和异常抛出

### 4. 重新生成 Pigeon 代码

如果修改了 `pigeons/app_install_api.dart`，需要重新生成代码：

```bash
dart run pigeon --input pigeons/app_install_api.dart \
  --dart_out lib/generated/app_install_api.dart \
  --swift_out ios/Classes/GeneratedAppInstallApi.swift \
  --kotlin_out android/src/main/kotlin/com/example/install_app_in_app_store/GeneratedAppInstallApi.kt \
  --kotlin_package com.example.install_app_in_app_store
```

## AppInstallConfig 字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| iosAppId | int? | App Store 上的应用 ID |
| iosIapId | String? | IAP 产品标识符（iOS 11.0+） |
| iosAffiliateToken | String? | Apple Affiliate Program 令牌 |
| iosCampaignToken | String? | App Analytics 活动令牌 |
| iosAdvertisingPartnerToken | String? | 广告合作伙伴令牌（iOS 9.3+） |
| iosProviderToken | String? | 提供商令牌（iOS 8.3+） |
| androidPackageName | String? | Android 包名 |
| url | String? | Web URL |

## 参考资源

- [Pigeon 文档](https://pub.dev/packages/pigeon)
- [SKStoreProductViewController 文档](https://developer.apple.com/documentation/storekit/skstoreproductviewcontroller)
- [App Store 参数文档](https://affiliate.itunes.apple.com/resources/documentation/getting-started/)
