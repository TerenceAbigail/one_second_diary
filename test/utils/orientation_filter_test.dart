import 'package:flutter_test/flutter_test.dart';
import 'package:one_second_diary/enums/video_orientation.dart';
import 'package:one_second_diary/utils/orientation_filter.dart';

void main() {
  group('scaleFilter', () {
    test('landscape pads mismatched clips into a 1920x1080 canvas with black bars', () {
      // Byte-for-byte the filter save_button.dart and save_photo_button.dart
      // have always used — this refactor must not change landscape output.
      expect(
        OrientationFilter.scaleFilter(VideoOrientation.landscape),
        'scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black',
      );
    });

    test('portrait crops mismatched clips to fill a 1080x1920 canvas, never pads', () {
      final String filter = OrientationFilter.scaleFilter(VideoOrientation.portrait);

      expect(filter, contains('scale=1080:1920'));
      expect(filter, contains('force_original_aspect_ratio=increase'));
      expect(filter, contains('crop=1080:1920'));
      expect(filter, isNot(contains('pad=')));
    });

    test('landscape and portrait never target each other\'s canvas', () {
      expect(OrientationFilter.scaleFilter(VideoOrientation.landscape), isNot(contains('1080:1920')));
      expect(OrientationFilter.scaleFilter(VideoOrientation.portrait), isNot(contains('1920:1080')));
    });
  });

  group('canvas dimensions', () {
    test('landscape targets a 1920x1080 canvas', () {
      expect(OrientationFilter.widthFor(VideoOrientation.landscape), 1920);
      expect(OrientationFilter.heightFor(VideoOrientation.landscape), 1080);
    });

    test('portrait targets a 1080x1920 canvas', () {
      expect(OrientationFilter.widthFor(VideoOrientation.portrait), 1080);
      expect(OrientationFilter.heightFor(VideoOrientation.portrait), 1920);
    });
  });
}
