import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_pin_usecase.dart';
import '../../domain/usecases/login_with_gmail_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyPinUseCase verifyPinUseCase;
  final LoginWithGmailUseCase loginWithGmailUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyPinUseCase,
    required this.loginWithGmailUseCase,
  }) : super(AuthInitial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyPinRequested>(_onVerifyPinRequested);
    on<GmailLoginRequested>(_onGmailLoginRequested);
    on<AuthReset>((event, emit) => emit(AuthInitial()));
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await sendOtpUseCase(SendOtpParams(event.phone));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(OtpSentSuccess(event.phone)),
    );
  }

  Future<void> _onVerifyPinRequested(
    VerifyPinRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyPinUseCase(
      VerifyPinParams(phone: event.phone, pin: event.pin),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onGmailLoginRequested(
    GmailLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result =
        await loginWithGmailUseCase(LoginWithGmailParams(event.idToken));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
