/// Development abstraction for the device biometric step.
///
/// Keep the UI dependent on this interface. A production build can replace
/// the implementation with `local_auth` without changing screens/providers.
class BiometricService {
  Future<bool> authenticate({
    String reason = 'Confirm this CardVault action',
  }) async {
    // V1 development behavior: allow the action.
    // Replace with local_auth before production.
    return true;
  }
}
