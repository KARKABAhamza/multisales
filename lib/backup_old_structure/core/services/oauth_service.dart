import 'package:flutter_appauth/flutter_appauth.dart';

class OAuthService {
  Future<TokenResponse?> refreshToken({required String refreshToken}) async {
    try {
      final result = await _appAuth.token(
        TokenRequest(
          '967872205422-tp6g10m8d504t0tleoqp6t4u5cuflsms.apps.googleusercontent.com',
          'com.googleusercontent.apps.967872205422-tp6g10m8d504t0tleoqp6t4u5cuflsms:/oauthredirect',
          refreshToken: refreshToken,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint:
                'https://accounts.google.com/o/oauth2/v2/auth',
            tokenEndpoint: 'https://oauth2.googleapis.com/token',
          ),
          scopes: ['openid', 'profile', 'email'],
        ),
      );
      return result;
    } catch (e) {
      throw 'Token refresh failed. Please try again.';
    }
  }

  static const FlutterAppAuth _appAuth = FlutterAppAuth();

  Future<AuthorizationTokenResponse?> signInWithOAuth() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          '967872205422-tp6g10m8d504t0tleoqp6t4u5cuflsms.apps.googleusercontent.com', // Google OAuth2 client ID for web
          'com.googleusercontent.apps.967872205422-tp6g10m8d504t0tleoqp6t4u5cuflsms:/oauthredirect', // Google redirect URI for flutter_appauth
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint:
                'https://accounts.google.com/o/oauth2/v2/auth',
            tokenEndpoint: 'https://oauth2.googleapis.com/token',
          ),
          scopes: ['openid', 'profile', 'email'],
        ),
      );
      return result;
    } catch (e) {
      throw 'OAuth2 sign-in failed. Please try again.';
    }
  }
}
// This file is now empty. All authentication logic has been removed for public-only app.
