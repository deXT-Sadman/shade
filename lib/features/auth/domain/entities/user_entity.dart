import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String phone;
  final String? email;
  final String publicKey;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.username,
    required this.phone,
    this.email,
    required this.publicKey,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, username, phone, email, publicKey, createdAt];
}
