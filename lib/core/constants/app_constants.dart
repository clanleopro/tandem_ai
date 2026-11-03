/// General application constants.
class AppConstants {
  AppConstants._();

  static const int maxFileSizeBytes = 25 * 1024 * 1024; // 25 MB
  static const Duration apiTimeout = Duration(minutes: 3);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 150);
  static const Duration engineerReplyDelay = Duration(milliseconds: 1500);
}

