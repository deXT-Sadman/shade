import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class SendOtpRequested extends AuthEvent {
  final String phone;
  const SendOtpRequested(this.phone);
  @override
  List<Object?> get props => [phone];
}

class VerifyPinRequested extends AuthEvent {
  final String phone;
  final String pin;
  const VerifyPinRequested({required this.phone, required this.pin});
  @override
  List<Object?> get props => [phone, pin];
}

class GmailLoginRequested extends AuthEvent {
  final String idToken;
  const GmailLoginRequested(this.idToken);
  @override
  List<Object?> get props => [idToken];
}

class AuthReset extends AuthEvent {
  const AuthReset();
}
