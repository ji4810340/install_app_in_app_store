package com.example.install_app_in_app_store

import androidx.annotation.NonNull
import android.content.Context
import android.content.Intent
import android.net.Uri

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** InstallAppInAppStorePlugin */
class InstallAppInAppStorePlugin: FlutterPlugin, MethodCallHandler, ActivityAware, AppInstallApi {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var activityBinding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "install_app_in_app_store")
    channel.setMethodCallHandler(this)
    AppInstallApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    AppInstallApi.setUp(binding.binaryMessenger, null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityBinding = binding
  }

  override fun onDetachedFromActivity() {
    activityBinding = null
  }

  override fun installApp(config: AppInstallConfig, callback: (Result<Boolean>) -> Unit) {
    val packageName = config.androidPackageName
    if (packageName.isNullOrEmpty()) {
      callback(Result.failure(FlutterError("INVALID_CONFIG", "androidPackageName is required for Android", null)))
      return
    }

    try {
      val intent = Intent(Intent.ACTION_VIEW).apply {
        data = Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
        setPackage("com.android.vending")
      }
      activityBinding?.activity?.startActivity(intent)
      callback(Result.success(true))
    } catch (e: Exception) {
      callback(Result.failure(FlutterError("INSTALL_FAILED", e.message, null)))
    }
  }
}
