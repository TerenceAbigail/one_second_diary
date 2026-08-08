import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../enums/video_orientation.dart';
import '../../routes/app_pages.dart';
import '../../utils/constants.dart';
import '../../utils/shared_preferences_util.dart';
import '../../utils/storage_utils.dart';
import '../../utils/theme.dart';
import '../home/profiles/widgets/orientation_picker.dart';

/// Shown once, immediately after the intro carousel — only for a fresh
/// install. IntroPage is never revisited once `showIntro` is false (see
/// main.dart's getInitialRoute) — and this page, not IntroPage, is what
/// sets that flag, only once the Default profile actually exists (see
/// _continue below). An existing install updating to this version already
/// has showIntro == false persisted from whatever version it first
/// installed, so it never reaches this page; its profile(s) stay
/// grandfathered as landscape exactly as before (StorageUtils.getOrientation's
/// default for a profile with no stored value).
///
/// Creates the Default profile with the chosen orientation before
/// continuing on to the rest of the launch flow — the one profile in the
/// app that isn't created through ProfilesPage's own "New profile" dialog,
/// but the same orientation requirement applies: no silent default.
class OnboardingOrientationPage extends StatefulWidget {
  const OnboardingOrientationPage({super.key});

  @override
  State<OnboardingOrientationPage> createState() => _OnboardingOrientationPageState();
}

class _OnboardingOrientationPageState extends State<OnboardingOrientationPage> {
  VideoOrientation? _selectedOrientation;
  bool _showError = false;
  // Guards against a double-tap (or a tap landing mid-transition) calling
  // this twice — createDefaultProfile's second call would hit
  // setOrientation's own "already set" guard and throw, unhandled, since
  // nothing here awaits it. Checked before anything else runs, so even two
  // taps in the same frame only let the first one through.
  bool _isSubmitting = false;

  Future<void> _continue() async {
    if (_isSubmitting) return;

    final VideoOrientation? orientation = _selectedOrientation;
    if (orientation == null) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _isSubmitting = true);
    await StorageUtils.createDefaultProfile(orientation);
    // Only now — the Default profile actually exists at this point, so a
    // force-quit before this can't leave the app in a state where
    // showIntro is false but no profile (or orientation choice) was ever
    // made. See IntroPage._onIntroEnd for the other half of this.
    await SharedPrefsUtil.putBool('showIntro', false);

    Get.offNamed(Routes.NEW_FEATURES_V152);
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = ThemeService().isDarkTheme() ? Colors.white : Colors.black;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'onboardingOrientationTitle'.tr,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'onboardingOrientationDesc'.tr,
                style: TextStyle(fontSize: 16.0, color: textColor),
              ),
              const SizedBox(height: 24),
              OrientationPicker(
                selectedOrientation: _selectedOrientation,
                showError: _showError,
                onChanged: (value) {
                  setState(() {
                    _selectedOrientation = value;
                    _showError = false;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                  ),
                  child: Text(
                    'done'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
