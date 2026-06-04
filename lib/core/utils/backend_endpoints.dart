class BackendEndPoint {
  static const String baseUrl = 'http://192.168.83.6:8000/api/';
  static const String signIn = '/auth/internal/login';
  static const String signUp = 'auth/register';
  static const String verifyEmail = 'auth/verify-email';
  static const String resendVerificationCode = 'auth/resend-verification-code';
  static const String forgotPassword = 'auth/forgot-password';
  static const String checkCode = 'auth/check-code';
  static const String resetPassword = 'auth/reset-password';
  static const String signOut = 'auth/logout';
  static const String projects = 'projects';
  static const String projectSpaces = 'spaces';
  static const String projectWorkItems = 'work-items';
  static const String sendFCMToken = 'fcm-token';

  static String get apiUrl => baseUrl;
}
