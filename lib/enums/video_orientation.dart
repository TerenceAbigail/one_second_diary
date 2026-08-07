/// The canvas a profile's saved clips and compiled movie target.
///
/// Set once per profile at creation time and immutable thereafter — see
/// `Profile.orientation`. [OrientationFilter] is what turns a value here into
/// the ffmpeg filter that fits a clip into that canvas.
enum VideoOrientation {
  landscape,
  portrait;
}
