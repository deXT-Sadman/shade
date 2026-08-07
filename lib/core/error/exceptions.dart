class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(
      [this.message = 'Session expired. Please log in again.']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
}
