/// The canvas a profile's saved clips and compiled movie target.
///
/// Set once per profile at creation time and immutable thereafter — see
/// `Profile.orientation`. [OrientationFilter] is what turns a value here into
/// the ffmpeg filter that fits a clip into that canvas.
enum VideoOrientation {
  landscape,
  portrait;

  /// Parses a persisted orientation string, defaulting to landscape for
  /// anything unrecognized — the grandfathering path every profile that
  /// predates this field (or has no stored value yet) falls through.
  static VideoOrientation parse(String stored) =>
      values.asNameMap()[stored] ?? VideoOrientation.landscape;
}
