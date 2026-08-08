import 'package:flutter_test/flutter_test.dart';
import 'package:one_second_diary/enums/video_orientation.dart';

void main() {
  group('parse', () {
    test('recognizes the two stored values', () {
      expect(VideoOrientation.parse('landscape'), VideoOrientation.landscape);
      expect(VideoOrientation.parse('portrait'), VideoOrientation.portrait);
    });

    test('defaults to landscape for a profile that predates this field', () {
      // SharedPrefsUtil.getString returns '' for a missing key — this is
      // the grandfathering path every pre-existing profile hits.
      expect(VideoOrientation.parse(''), VideoOrientation.landscape);
    });

    test('defaults to landscape for any unrecognized value', () {
      // Corrupt prefs, or a value written by a future build this one
      // doesn't know about — never crash, just fall back safely.
      expect(VideoOrientation.parse('sideways'), VideoOrientation.landscape);
    });
  });
}
