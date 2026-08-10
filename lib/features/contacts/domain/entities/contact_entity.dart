import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id;
  final String username;
  final String phone;
  final String? avatarUrl;

  const ContactEntity({
    required this.id,
    required this.username,
    required this.phone,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, username, phone, avatarUrl];
}
