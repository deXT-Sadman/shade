import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phone);
  Future<AuthResponseModel> verifyPin({
    required String phone,
    required String pin,
    required String publicKey,
  });
  Future<AuthResponseModel> loginWithGmail({
    required String idToken,
    required String publicKey,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<void> sendOtp(String phone) async {
    await apiClient.safeRequest(
      () => apiClient.dio.post('/auth/send-otp', data: {'phone': phone}),
    );
  }

  @override
  Future<AuthResponseModel> verifyPin({
    required String phone,
    required String pin,
    required String publicKey,
  }) async {
    final response = await apiClient.safeRequest(
      () => apiClient.dio.post('/auth/verify-pin', data: {
        'phone': phone,
        'pin': pin,
        'publicKey': publicKey,
      }),
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> loginWithGmail({
    required String idToken,
    required String publicKey,
  }) async {
    final response = await apiClient.safeRequest(
      () => apiClient.dio.post('/auth/gmail', data: {
        'idToken': idToken,
        'publicKey': publicKey,
      }),
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
