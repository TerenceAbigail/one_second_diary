import 'package:flutter_test/flutter_test.dart';
import 'package:one_second_diary/enums/video_orientation.dart';
import 'package:one_second_diary/utils/shared_preferences_util.dart';
import 'package:one_second_diary/utils/storage_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPrefsUtil.debugReset();
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsUtil.getInstance();
  });

  group('setOrientation', () {
    test('persists the orientation for a brand-new profile', () async {
      await StorageUtils.setOrientation('Alice', VideoOrientation.portrait);

      expect(StorageUtils.getOrientation('Alice'), VideoOrientation.portrait);
    });

    test('throws when the profile already has a stored orientation', () async {
      await StorageUtils.setOrientation('Alice', VideoOrientation.portrait);

      expect(
        () => StorageUtils.setOrientation('Alice', VideoOrientation.landscape),
        throwsStateError,
      );
    });

    test('does not overwrite the existing value when it throws', () async {
      await StorageUtils.setOrientation('Alice', VideoOrientation.portrait);

      try {
        await StorageUtils.setOrientation('Alice', VideoOrientation.landscape);
      } catch (_) {
        // Expected — asserted above, ignored here.
      }

      expect(StorageUtils.getOrientation('Alice'), VideoOrientation.portrait);
    });
  });

  group('deleteSpecificProfileFolder', () {
    test('clears the stored orientation so the name can be reused', () async {
      await StorageUtils.setOrientation('Bob', VideoOrientation.portrait);

      await StorageUtils.deleteSpecificProfileFolder('Bob');

      // Grandfathering default, same as a name that was never used.
      expect(StorageUtils.getOrientation('Bob'), VideoOrientation.landscape);
      // And the name is free to be reused without setOrientation throwing.
      await StorageUtils.setOrientation('Bob', VideoOrientation.landscape);
    });
  });
}
