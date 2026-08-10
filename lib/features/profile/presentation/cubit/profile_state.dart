import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final String? publicKeyFingerprint;
  final String? userId;
  final bool isLoggingOut;

  const ProfileState({
    this.isLoading = true,
    this.publicKeyFingerprint,
    this.userId,
    this.isLoggingOut = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? publicKeyFingerprint,
    String? userId,
    bool? isLoggingOut,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      publicKeyFingerprint: publicKeyFingerprint ?? this.publicKeyFingerprint,
      userId: userId ?? this.userId,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, publicKeyFingerprint, userId, isLoggingOut];
}
