import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../enums/video_orientation.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';

/// The landscape/portrait choice used wherever a profile's orientation must
/// be picked — profile creation (ProfilesPage) and first-launch onboarding
/// (OnboardingOrientationPage). Controlled, not stateful: the caller owns
/// [selectedOrientation] and [showError], and updates them from [onChanged]
/// — both callers already need their own state for the surrounding form
/// (a name field, or a "Continue" button), so there's nothing this widget
/// would gain by owning a duplicate copy of the same two values.
///
/// No option starts selected regardless of caller — every call site of this
/// widget exists specifically because there's no silent default to fall
/// back to; see the two callers' own doc comments for why.
class OrientationPicker extends StatelessWidget {
  const OrientationPicker({
    super.key,
    required this.selectedOrientation,
    required this.onChanged,
    required this.showError,
  });

  final VideoOrientation? selectedOrientation;
  final ValueChanged<VideoOrientation?> onChanged;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final Color textColor = ThemeService().isDarkTheme()
        ? Colors.white
        : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('orientation'.tr, style: TextStyle(color: textColor)),
        ),
        RadioGroup<VideoOrientation>(
          groupValue: selectedOrientation,
          onChanged: onChanged,
          child: Column(
            children: [
              RadioListTile<VideoOrientation>(
                activeColor: AppColors.green,
                value: VideoOrientation.landscape,
                title: Text('landscape'.tr, style: TextStyle(color: textColor)),
              ),
              RadioListTile<VideoOrientation>(
                activeColor: AppColors.green,
                value: VideoOrientation.portrait,
                title: Text('portrait'.tr, style: TextStyle(color: textColor)),
              ),
            ],
          ),
        ),
        if (showError)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'profileOrientationRequired'.tr,
              style: const TextStyle(color: AppColors.mainColor, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
