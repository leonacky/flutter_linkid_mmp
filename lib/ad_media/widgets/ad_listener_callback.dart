class AdListenerCallback {
  AdListenerCallback({
    this.onAdError,
    this.onAdClick,
    this.onAdImpression,
    this.onAdDismissed,
    this.onAdCompleted,
  });

  final void Function(
    Object error,
    String adId,
    String adType,
  )? onAdError;

  final void Function(
    String adId,
    String adType,
    String productId,
    String? actionType,
    String? actionData,
  )? onAdClick;

  final void Function(
    String adId,
    String adType,
    String productId,
  )? onAdImpression;

  final void Function(
    String adId,
    String adType,
  )? onAdDismissed;

  final void Function(
    String adId,
    String adType,
  )? onAdCompleted;
}
