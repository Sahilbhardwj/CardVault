/// Cross-platform V1 placeholder for screen-security integration.
///
/// On Android this can later map to FLAG_SECURE. Keep it out of feature UI.
class SecureScreenService {
  Future<void> enable() async {}
  Future<void> disable() async {}
}
