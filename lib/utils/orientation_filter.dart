import '../enums/video_orientation.dart';

/// Builds the ffmpeg video filter that fits a clip of any input size into a
/// [VideoOrientation]'s output canvas.
///
/// This is the single place that decides how a mismatched clip gets fit into
/// a profile's canvas, so that per-clip video save, photo-to-video save, and
/// movie compilation's legacy-clip normalization all agree instead of each
/// building their own filter string.
///
/// - Landscape pads a mismatched clip into 1920x1080 with black bars — the
///   filter the app has always used.
/// - Portrait crops a mismatched clip to fill a 1080x1920 canvas instead, so
///   a portrait profile never shows letterboxing.
///
/// Neither branch needs the source clip's actual dimensions in Dart: ffmpeg's
/// own `force_original_aspect_ratio`/`pad`/`crop` filters resolve those from
/// the decoded input at run time via their `iw`/`ih`/`ow`/`oh` variables.
class OrientationFilter {
  OrientationFilter._();

  static const int _landscapeWidth = 1920;
  static const int _landscapeHeight = 1080;
  static const int _portraitWidth = 1080;
  static const int _portraitHeight = 1920;

  /// The canvas width [orientation] targets.
  static int widthFor(VideoOrientation orientation) {
    switch (orientation) {
      case VideoOrientation.landscape:
        return _landscapeWidth;
      case VideoOrientation.portrait:
        return _portraitWidth;
    }
  }

  /// The canvas height [orientation] targets.
  static int heightFor(VideoOrientation orientation) {
    switch (orientation) {
      case VideoOrientation.landscape:
        return _landscapeHeight;
      case VideoOrientation.portrait:
        return _portraitHeight;
    }
  }

  /// The ffmpeg `-vf` filter fragment that fits a clip into [orientation]'s
  /// canvas.
  static String scaleFilter(VideoOrientation orientation) {
    final int width = widthFor(orientation);
    final int height = heightFor(orientation);

    switch (orientation) {
      case VideoOrientation.landscape:
        return 'scale=$width:$height:force_original_aspect_ratio=decrease,'
            'pad=$width:$height:(ow-iw)/2:(oh-ih)/2:black';
      case VideoOrientation.portrait:
        return 'scale=$width:$height:force_original_aspect_ratio=increase,'
            'crop=$width:$height';
    }
  }
}
