class DeepLinkIOSParameter {
  String? bundleID;
  String? appStoreID;
  String? appStoreURL;
  String? customSchema;

  DeepLinkIOSParameter({
    required this.bundleID,
    required this.appStoreID,
    this.appStoreURL,
    this.customSchema,
  });

  Map<String, dynamic> buildParams() {
    Map<String, dynamic> params = {};
    if (bundleID?.isNotEmpty == true) {
      params["bundleID"] = bundleID;
    }
    if (appStoreID?.isNotEmpty == true) {
      params['appStoreID'] = appStoreID;
      params["ios_store"] = "https://apps.apple.com/app/id${appStoreID!}?mt=8";
    }
    if (appStoreURL?.isNotEmpty == true &&
        appStoreURL?.startsWith("http") == true &&
        appStoreURL?.contains("apps.apple.com") == true) {
      params["ios_store"] = appStoreURL;
    }
    if (customSchema?.isNotEmpty == true) {
      params["ios_custom_protocol"] = customSchema;
    }
    return params;
  }
}
