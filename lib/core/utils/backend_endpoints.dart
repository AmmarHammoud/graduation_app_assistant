abstract class BackendEndPoint {
  static const String _url = 'http://192.168.83.6:8000';
  static const apiUrl = '$_url/api';
  //auth endpoints
  static const String signIn = '/auth/internal/login';
  static const String signUp = '/api/signup';
  static const String signOut = '/api/signout';

  //Projects
  static const String ownerProjects = '/owner/projects';
  static const String projectSpaces = 'spaces';
  static const String projectWorkItems = 'work-items';

  //Profile
  static const String ownerProfile = '/owner/account';



  static const String forgotPassword = '/api/forgotPassword';
  static const String checkCode = '/api/checkCode';
  static const String resetPassword = '/api/resetPassword';
  static const String verifyEmail = '/api/verifyEmail';
  static const String resendVerificationCode = '/api/resendVerificationCode';

  static const String getNotifications = "notifications";

  static const String sendFCMToken = "/api/fcm-token";
}
