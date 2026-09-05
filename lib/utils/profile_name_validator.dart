/// Why a candidate profile name was rejected. The creation dialog owns the
/// localized copy shown for each; this only owns the decision.
enum ProfileNameError { empty, invalidCharacters, reserved, duplicate }

class ProfileNameValidator {
  ProfileNameValidator._();

  /// Validates [rawValue] as a new profile name, or `null` if it's fine.
  ///
  /// The emptiness check runs against the trimmed value — a name that's
  /// only whitespace is empty, not a valid one. Left untrimmed, "   "
  /// passes this check (it isn't the empty string) and every check below
  /// it (space is an allowed character) and then collapses to '' at the
  /// call site's own `.trim()`, which is the exact key this app reserves
  /// for the Default profile elsewhere (`AppPaths.profileVideos`,
  /// `StorageUtils`'s per-profile keys) — silently aliasing a "new"
  /// profile onto Default's storage instead of getting rejected.
  ///
  /// Every other check runs against [rawValue] as typed, untrimmed —
  /// deliberately, so this only changes the one broken case rather than
  /// also loosening the allowed-characters check (e.g. a trailing tab
  /// should still be rejected as an invalid character, not silently
  /// dropped and accepted).
  static ProfileNameError? validate(
    String rawValue, {
    required List<String> existingLabels,
    required String localizedDefaultLabel,
  }) {
    if (rawValue.trim().isEmpty) return ProfileNameError.empty;
    if (!rawValue.contains(RegExp(r'^[\w\d _-]+$'))) {
      return ProfileNameError.invalidCharacters;
    }

    final String lowerValue = rawValue.toLowerCase().trim();
    if (lowerValue == 'default' ||
        lowerValue == localizedDefaultLabel.toLowerCase()) {
      return ProfileNameError.reserved;
    }

    if (existingLabels.any((label) => label.toLowerCase() == lowerValue)) {
      return ProfileNameError.duplicate;
    }

    return null;
  }
}
