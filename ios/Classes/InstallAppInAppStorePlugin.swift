import Flutter
import UIKit
import StoreKit

public class InstallAppInAppStorePlugin: NSObject, FlutterPlugin {
  private var productViewController: SKStoreProductViewController?

  public static func register(with registrar: FlutterPluginRegistrar) {
    AppInstallApiSetup.setUp(binaryMessenger: registrar.messenger(), api: InstallAppInAppStorePlugin())
  }

  public static func dummy(methodCall: FlutterMethodCall) {}
}

extension InstallAppInAppStorePlugin: AppInstallApi {
  func installApp(config: AppInstallConfig) throws {
    guard let root = UIApplication.shared.keyWindow?.rootViewController else {
      throw NSError(domain: "InstallAppInAppStore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to find root view controller"])
    }

    self.productViewController = SKStoreProductViewController()

    var params: [String: Any] = [:]
    
    if let iosAppId = config.iosAppId {
      params[SKStoreProductParameterITunesItemIdentifier] = iosAppId
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

    self.productViewController?.loadProduct(withParameters: params, completionBlock: nil)
    self.productViewController?.delegate = self
    
    if root.presentedViewController != nil {
      root.dismiss(animated: true) {
        root.present(self.productViewController!, animated: true, completion: nil)
      }
    } else {
      root.present(self.productViewController!, animated: true, completion: nil)
    }
  }
}

extension InstallAppInAppStorePlugin: SKStoreProductViewControllerDelegate {
  public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
    viewController.dismiss(animated: true, completion: nil)
  }
}
