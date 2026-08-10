import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shade/features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_screen.dart';
import '../../../../core/di/injection_container.dart' as di;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleGmailSignIn(BuildContext context) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return; // user cancelled
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        _showError(context, 'Failed to retrieve Google ID token.');
        return;
      }
      if (!context.mounted) return;
      context.read<AuthBloc>().add(GmailLoginRequested(idToken));
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Gmail sign-in failed. Please try again.');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            _showError(context, state.message);
          }
          if (state is OtpSentSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AuthBloc>(),
                  child: OtpScreen(phone: state.phone),
                ),
              ),
            );
          }
          if (state is AuthSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    const Icon(Icons.shield_outlined,
                        size: 64, color: AppColors.neonCyan),
                    const SizedBox(height: 16),
                    Text(
                      'Shade',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'End-to-end encrypted. No one else can read your messages.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 48),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Phone number (e.g. +8801XXXXXXXXX)',
                        prefixIcon: Icon(Icons.phone_outlined,
                            color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final phone = _phoneController.text.trim();
                              if (phone.isEmpty) {
                                _showError(
                                    context, 'Enter a valid phone number.');
                                return;
                              }
                              context
                                  .read<AuthBloc>()
                                  .add(SendOtpRequested(phone));
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.bgPrimary),
                            )
                          : const Text('Send OTP'),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OR',
                              style: TextStyle(color: AppColors.textDisabled)),
                        ),
                        Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed:
                          isLoading ? null : () => _handleGmailSignIn(context),
                      icon: const Icon(Icons.mail_outline,
                          color: AppColors.neonMagenta),
                      label: const Text('Continue with Gmail'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
