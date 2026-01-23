import 'package:pigeon/pigeon.dart';

const PigeonOptions pigeonOptions = PigeonOptions(
  dartPackageName: 'install_app_in_app_store',
);

class AppInstallConfig {
  int? iosAppId;
  String? iosIapId;
  String? iosAffiliateToken;
  String? iosCampaignToken;
  String? iosAdvertisingPartnerToken;
  String? iosProviderToken;
  String? androidPackageName;
  String? url;
}


@HostApi()
abstract class AppInstallApi {
  @async
  bool installApp(AppInstallConfig config);
}
