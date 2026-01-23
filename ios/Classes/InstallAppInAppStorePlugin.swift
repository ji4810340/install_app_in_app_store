import Flutter
import UIKit
import StoreKit

class AppInstallPluginError: Error {
  let code: String
  let message: String?
  let details: [String: Any]?
  
  init(code: String, message: String?, details: [String: Any]?) {
    self.code = code
    self.message = message
    self.details = details
  }
  
  static let noRootViewController = AppInstallPluginError(
    code: "NO_ROOT_VIEW_CONTROLLER",
    message: "Unable to find root view controller",
    details: nil
  )
  
  func toFlutterError() -> FlutterError {
    return FlutterError(code: code, message: message, details: details)
  }
}

public class InstallAppInAppStorePlugin: NSObject, FlutterPlugin {
  private var productViewController: SKStoreProductViewController?

  public static func register(with registrar: FlutterPluginRegistrar) {
    AppInstallApiSetup.setUp(binaryMessenger: registrar.messenger(), api: InstallAppInAppStorePlugin())
  }

  public static func dummy(methodCall: FlutterMethodCall) {}
  
  private func parseSkError(_ error: NSError?) -> AppInstallPluginError {
    guard let error = error else {
      return AppInstallPluginError(code: "UNKNOWN_ERROR", message: "Unknown error occurred", details: nil)
    }
    
    let errorCode = error.code
    let errorDomain = error.domain
    var code = "UNKNOWN_ERROR"
    var message = "Unknown error occurred"
    var details: [String: Any]? = [
      "domain": errorDomain,
      "code": errorCode,
      "description": error.localizedDescription
    ]
    
    if errorDomain == SKErrorDomain {
      switch errorCode {
      case 5:
        code = "STORE_PRODUCT_NOT_AVAILABLE"
        message = "The app is not available in your region or country"
        details?["reason"] = "storeProductNotAvailable"
      case 0:
        code = "UNKNOWN_SK_ERROR"
        message = "Failed to load product from App Store (network issue or invalid configuration)"
        details?["reason"] = "unknown"
      case 1:
        code = "CLOUD_SERVICE_PERMISSION_DENIED"
        message = "Cloud service permission denied"
        details?["reason"] = "cloudServicePermissionDenied"
      case 2:
        code = "CLOUD_SERVICE_NETWORK_CONNECTION_FAILED"
        message = "Cloud service network connection failed"
        details?["reason"] = "cloudServiceNetworkConnectionFailed"
      case 3:
        code = "CLOUD_SERVICE_REVOKED"
        message = "Cloud service revoked"
        details?["reason"] = "cloudServiceRevoked"
      default:
        code = "SK_ERROR_\(errorCode)"
        message = error.localizedDescription
      }
      return AppInstallPluginError(code: code, message: message, details: details)
    } else if errorDomain == NSURLErrorDomain {
      return AppInstallPluginError(code: "NETWORK_ERROR", message: "Network connection failed", details: details)
    } else if errorDomain == NSCocoaErrorDomain {
      return AppInstallPluginError(code: "INVALID_PARAMETER", message: "Invalid parameter or configuration", details: details)
    }
    
    return AppInstallPluginError(code: code, message: message, details: details)
  }
}
extension FlutterError : @retroactive Error {
    
}
extension InstallAppInAppStorePlugin: AppInstallApi {
  func installApp(config: AppInstallConfig, completion: @escaping (Result<Bool, Error>) -> Void) {
    guard let root = UIApplication.shared.keyWindow?.rootViewController else {
      let error = FlutterError(
        code: "NO_ROOT_VIEW_CONTROLLER",
        message: "Unable to find root view controller",
        details: nil
      )
      completion(.failure(error))
      return
    }

    self.productViewController = SKStoreProductViewController()

    var params: [String: Any] = [:]
    
    if let iosAppId = config.iosAppId {
      params[SKStoreProductParameterITunesItemIdentifier] = NSNumber(value: iosAppId)
    }
    
    if let iosAffiliateToken = config.iosAffiliateToken {
      params[SKStoreProductParameterAffiliateToken] = iosAffiliateToken
    }
    
    if let iosCampaignToken = config.iosCampaignToken {
      params[SKStoreProductParameterCampaignToken] = iosCampaignToken
    }
    
    if #available(iOS 11.0, *) {
      if let iosIapId = config.iosIapId {
        params[SKStoreProductParameterProductIdentifier] = iosIapId
      }
    }
    
    if #available(iOS 8.3, *) {
      if let iosProviderToken = config.iosProviderToken {
        params[SKStoreProductParameterProviderToken] = iosProviderToken
      }
    }
    
    if #available(iOS 9.3, *) {
      if let iosAdvertisingPartnerToken = config.iosAdvertisingPartnerToken {
        params[SKStoreProductParameterAdvertisingPartnerToken] = iosAdvertisingPartnerToken
      }
    }

    self.productViewController?.delegate = self

    self.productViewController?.loadProduct(withParameters: params) { [weak self] isFound, error in
      guard let self = self else { return }
      
      if isFound {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            let error = FlutterError(
              code: "NO_ROOT_VIEW_CONTROLLER",
              message: "Unable to find root view controller",
              details: nil
            )
            completion(.failure(error))
          return
        }
        
        if root.presentedViewController != nil {
          root.dismiss(animated: true) {
            root.present(self.productViewController!, animated: true, completion: nil)
          }
        } else {
          root.present(self.productViewController!, animated: true, completion: nil)
        }
        completion(.success(true))
      } else {
        let pluginError = self.parseSkError(error as NSError?)
          completion(.failure(pluginError.toFlutterError()))
        print("SKStoreProductViewController loadProduct error: \(pluginError.code) - \(pluginError.message ?? "Unknown")")
      }
    }
  }
}

extension InstallAppInAppStorePlugin: SKStoreProductViewControllerDelegate {
  public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
    viewController.dismiss(animated: true, completion: nil)
  }
}
