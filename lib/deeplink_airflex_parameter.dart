class DeepLinkAirflexParameter {
  String? shortLinkId;
  String? name;
  String? source;
  String? code;
  String? medium;
  String? campaign;
  String? term;
  String? content;
  String? redirectUrl;
  Map<String, dynamic> customParams = {};

  DeepLinkAirflexParameter({
    this.shortLinkId,
    required this.name,
    this.source,
    this.code,
    this.medium,
    this.campaign,
    this.term,
    this.content,
    this.redirectUrl,
  });

  addCustomParam(String key, dynamic value) {
    customParams[key] = value;
  }

  addCustomParams(Map<String, dynamic> params) {
    customParams.addAll(params);
  }

  Map<String, dynamic> buildParams() {
    Map<String, dynamic> params = {};
    params.addAll(customParams);
    if (shortLinkId?.isNotEmpty == true) {
      params["short_link_id"] = shortLinkId;
    }
    if (name?.isNotEmpty == true) {
      params["name"] = name;
    }
    if (source?.isNotEmpty == true) {
      params["utm_source"] = source;
    }
    if (code?.isNotEmpty == true) {
      params["code"] = code;
    }
    if (medium?.isNotEmpty == true) {
      params["utm_medium"] = medium;
    }
    if (campaign?.isNotEmpty == true) {
      params["utm_campaign"] = campaign;
    }
    if (term?.isNotEmpty == true) {
      params["utm_term"] = term;
    }
    if (content?.isNotEmpty == true) {
      params["utm_content"] = content;
    }
    if (redirectUrl?.isNotEmpty == true) {
      params["redirect_url"] = redirectUrl;
    }
    return params;
  }
}
