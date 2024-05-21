class DeepLinkAndroidParameter {
  String? packageName;
  String? playStoreURL;
  String? customSchema;

  DeepLinkAndroidParameter({
    required this.packageName,
    this.playStoreURL,
    this.customSchema,
  });

  Map<String, dynamic> buildParams() {
    Map<String, dynamic> params = {};
    if (packageName?.isNotEmpty == true) {
      params["package_name"] = packageName;
      params["android_store"] =
          "https://play.google.com/store/apps/details?id=${packageName!}";
    }
    if (playStoreURL?.isNotEmpty == true &&
        playStoreURL?.startsWith("http") == true &&
        playStoreURL?.contains("play.google.com") == true) {
      params["android_store"] = playStoreURL;
    }
    if (customSchema?.isNotEmpty == true) {
      params["android_custom_protocol"] = customSchema;
    }
    return params;
  }
}
