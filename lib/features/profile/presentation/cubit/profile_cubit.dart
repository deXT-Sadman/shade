import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FlutterSecureStorage secureStorage;

  ProfileCubit({required this.secureStorage}) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    final publicKey = await secureStorage.read(key: AppConstants.kPublicKey);
    final userId = await secureStorage.read(key: AppConstants.kUserId);
    final fingerprint = publicKey != null ? _fingerprint(publicKey) : null;
    emit(state.copyWith(
        isLoading: false, publicKeyFingerprint: fingerprint, userId: userId));
  }

  /// Short human-readable fingerprint derived from the public key, purely
  /// for display/verification purposes (e.g. comparing keys out-of-band).
  String _fingerprint(String publicKeyPem) {
    final hash = sha256.convert(utf8.encode(publicKeyPem)).toString();
    final buffer = StringBuffer();
    for (int i = 0; i < 16; i += 4) {
      if (i > 0) buffer.write(' ');
      buffer.write(hash.substring(i, i + 4).toUpperCase());
    }
    return buffer.toString();
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoggingOut: true));
    await secureStorage.delete(key: AppConstants.kJwtToken);
    await secureStorage.delete(key: AppConstants.kUserId);
    // RSA key pair is intentionally NOT deleted here, so the same identity
    // (and any messages encrypted to this device's public key) persists
    // across future logins on this device.
  }
}
