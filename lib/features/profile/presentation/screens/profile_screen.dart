import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ProfileCubit>()..loadProfile(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile Settings')),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.isLoggingOut) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.neonCyan));
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.bgElevated,
                        child: Icon(Icons.person,
                            size: 40, color: AppColors.neonCyan),
                      ),
                      const SizedBox(height: 12),
                      Text(state.userId ?? 'Unknown user',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.verified_user,
                                color: AppColors.success, size: 18),
                            SizedBox(width: 8),
                            Text('Encryption Key: Active',
                                style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Fingerprint',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                          state.publicKeyFingerprint ?? 'Not generated',
                          style: const TextStyle(
                            color: AppColors.neonCyan,
                            fontFamily: 'monospace',
                            fontSize: 15,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const ListTile(
                  leading: Icon(Icons.devices_outlined,
                      color: AppColors.textSecondary),
                  title: Text('Active Sessions',
                      style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: Text('This device only',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                const Divider(color: AppColors.border),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => context.read<ProfileCubit>().logout(),
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Log Out',
                      style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
