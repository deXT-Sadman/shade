class AppConstants {
  AppConstants._();

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://your-backend-api.com/api/v1',
  );

  // Secure storage keys
  static const String kPrivateKey = 'shadow_chat_private_key';
  static const String kPublicKey = 'shadow_chat_public_key';
  static const String kJwtToken = 'shadow_chat_jwt_token';
  static const String kUserId = 'shadow_chat_user_id';

  static const Duration apiTimeout = Duration(seconds: 10);
  static const int rsaKeySize = 2048;
}
