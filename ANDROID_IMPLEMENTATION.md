# Android 实现说明

## 概述

Android 插件使用 Pigeon 生成的接口来实现应用安装功能。通过 Intent 打开 Google Play Store 应用详情页面。

## 生成的文件

- `android/src/main/kotlin/com/example/install_app_in_app_store/GeneratedAppInstallApi.kt` - Pigeon 生成的接口和数据类

## 实现文件

- `android/src/main/kotlin/com/example/install_app_in_app_store/InstallAppInAppStorePlugin.kt` - 插件实现

## 核心实现

### 1. 插件类实现

`InstallAppInAppStorePlugin` 实现了以下接口：
- `FlutterPlugin` - Flutter 插件基础接口
- `MethodCallHandler` - 方法调用处理（保持向后兼容）
- `ActivityAware` - Activity 生命周期管理
- `AppInstallApi` - Pigeon 生成的接口

### 2. 安装逻辑

```kotlin
override fun installApp(config: AppInstallConfig) {
    val packageName = config.androidPackageName
    if (packageName.isNullOrEmpty()) {
      throw FlutterError("INVALID_CONFIG", "androidPackageName is required for Android", null)
    }

    try {
      val intent = Intent(Intent.ACTION_VIEW).apply {
        data = Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
        setPackage("com.android.vending")
      }
      activityBinding?.activity?.startActivity(intent)
    } catch (e: Exception) {
      throw FlutterError("INSTALL_FAILED", e.message, null)
    }
}
```

### 3. 关键特性

- **包名验证** - 确保 `androidPackageName` 不为空
- **Google Play Store 集成** - 使用官方 Google Play Store URI
- **异常处理** - 捕获并报告错误
- **Activity 管理** - 通过 `ActivityAware` 接口管理 Activity 生命周期

## 使用示例

```dart
final config = AppInstallConfig(
  androidPackageName: 'com.example.app',
);

try {
  await plugin.installApp(config);
} catch (e) {
  print('Error: $e');
}
```

## 所需权限

在 `android/app/src/main/AndroidManifest.xml` 中，需要确保有网络权限：

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 错误处理

| 错误代码 | 说明 |
|---------|------|
| INVALID_CONFIG | androidPackageName 为空或无效 |
| INSTALL_FAILED | 启动 Intent 失败 |

## 测试

在 Android 设备或模拟器上测试时，确保：
1. 已安装 Google Play Store（模拟器可能需要 Google Play 版本）
2. 指定的包名是有效的应用包名
3. 设备有网络连接

## 与 iOS 的区别

| 特性 | iOS | Android |
|------|-----|---------|
| 显示方式 | SKStoreProductViewController | Google Play Store App/Web |
| 支持的参数 | iosAppId, iosIapId, tokens 等 | androidPackageName |
| 用户体验 | 应用内显示 | 跳转到 Play Store |
