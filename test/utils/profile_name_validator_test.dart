import 'package:flutter_test/flutter_test.dart';
import 'package:one_second_diary/utils/profile_name_validator.dart';

void main() {
  group('validate', () {
    test('accepts a normal name with no existing profiles', () {
      expect(
        ProfileNameValidator.validate('Bob', existingLabels: const [], localizedDefaultLabel: 'Default'),
        isNull,
      );
    });

    test('rejects an empty name', () {
      expect(
        ProfileNameValidator.validate('', existingLabels: const [], localizedDefaultLabel: 'Default'),
        ProfileNameError.empty,
      );
    });

    test('rejects a whitespace-only name — trimming it must not silently produce the '
        'empty string this app reserves for the Default profile', () {
      expect(
        ProfileNameValidator.validate('   ', existingLabels: const [], localizedDefaultLabel: 'Default'),
        ProfileNameError.empty,
      );
    });

    test('rejects special characters', () {
      expect(
        ProfileNameValidator.validate('Bob/Alice', existingLabels: const [], localizedDefaultLabel: 'Default'),
        ProfileNameError.invalidCharacters,
      );
    });

    test('rejects a trailing tab as an invalid character rather than trimming it away', () {
      // Only the emptiness check trims — every other check runs on the
      // value as typed, so this must stay rejected exactly like it was
      // before the whitespace-collapses-to-empty fix, not silently
      // cleaned up and accepted as "Bob".
      expect(
        ProfileNameValidator.validate('Bob\t', existingLabels: const [], localizedDefaultLabel: 'Default'),
        ProfileNameError.invalidCharacters,
      );
    });

    test('allows word characters, digits, spaces, underscores and hyphens', () {
      expect(
        ProfileNameValidator.validate('Bob_Trip-2024 2', existingLabels: const [], localizedDefaultLabel: 'Default'),
        isNull,
      );
    });

    test('rejects the reserved English "default" name, case-insensitively', () {
      expect(
        ProfileNameValidator.validate('DEFAULT', existingLabels: const [], localizedDefaultLabel: 'Default'),
        ProfileNameError.reserved,
      );
    });

    test('rejects the localized default label too', () {
      expect(
        ProfileNameValidator.validate('Estandar',
            existingLabels: const [], localizedDefaultLabel: 'Estandar'),
        ProfileNameError.reserved,
      );
    });

    test('rejects a name that collides with an existing profile, case-insensitively', () {
      expect(
        ProfileNameValidator.validate('bob',
            existingLabels: const ['Bob'], localizedDefaultLabel: 'Default'),
        ProfileNameError.duplicate,
      );
    });

    test('ignores leading/trailing whitespace when checking for duplicates', () {
      expect(
        ProfileNameValidator.validate('  Bob  ',
            existingLabels: const ['Bob'], localizedDefaultLabel: 'Default'),
        ProfileNameError.duplicate,
      );
    });
  });
}
