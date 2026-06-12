/// Default error messages used by [Failure] subtypes.
abstract class DefaultErrorMessages {
  const DefaultErrorMessages._();

  // ─── Network / HTTP failures ──────────────────────────────────────
  static const String timeout =
      'Uh-oh! Connection timed out. Please try again.';
  static const String connection =
      'Uh-oh! There seems to be no internet connection.';
  static const String requestCancelled = 'Uh-oh! Request was cancelled.';

  // ─── HTTP status code failures ────────────────────────────────────
  static const String badRequest = 'Invalid request. Please try again.';
  static const String unauthorized =
      'Uh-oh! Session expired. Please log in again.';
  static const String forbidden =
      'Uh-oh! You don\'t have permission to access this resource.';
  static const String notFound = 'Uh-oh! The requested resource was not found.';
  static const String conflict = 'Uh-oh! A conflict occurred. Please try again.';
  static const String internalServer =
      'Something went wrong on our end. Please try again later.';
  static const String serviceUnavailable =
      'Service is temporarily unavailable. Please try again later.';

  // ─── API-level failures ───────────────────────────────────────────
  static const String api = 'Request failed. Please try again.';

  // ─── Other failures ───────────────────────────────────────────────
  static const String network = 'No internet connection.';
  static const String unknown = 'An unknown error occurred.';
}