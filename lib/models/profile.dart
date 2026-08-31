import 'package:flutter/material.dart';

import '../enums/video_orientation.dart';

@immutable
class Profile {
  const Profile({
    required this.label,
    this.isDefault = false,
    this.orientation = VideoOrientation.landscape,
  });

  final String label;
  final bool isDefault;

  /// Set once, at profile-creation time, and immutable thereafter — there is
  /// no code path that changes an existing profile's orientation in place.
  /// Defaults to landscape, which is also what every profile that predates
  /// this field is treated as (see `StorageUtils.getOrientation`).
  final VideoOrientation orientation;
}
