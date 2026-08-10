import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import '../widgets/contact_tile.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Timer? _debounce;
  final _controller = TextEditingController();

  void _onChanged(BuildContext context, String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<ContactsBloc>().add(ContactsSearchChanged(value));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ContactsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Contacts')),
        body: Builder(
          builder: (context) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.textPrimary),
                  onChanged: (value) => _onChanged(context, value),
                  decoration: const InputDecoration(
                    hintText: 'Search by username or phone',
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.textSecondary),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ContactsBloc, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsInitial) {
                      return const Center(
                        child: Text('Search for people by username or phone',
                            style: TextStyle(color: AppColors.textDisabled)),
                      );
                    }
                    if (state is ContactsLoading) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.neonCyan));
                    }
                    if (state is ContactsError) {
                      return Center(
                        child: Text(state.message,
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                      );
                    }
                    if (state is ContactsLoaded) {
                      if (state.results.isEmpty) {
                        return const Center(
                          child: Text('No users found',
                              style: TextStyle(color: AppColors.textDisabled)),
                        );
                      }
                      return ListView.separated(
                        itemCount: state.results.length,
                        separatorBuilder: (_, __) => const Divider(
                            height: 1, indent: 72, color: AppColors.border),
                        itemBuilder: (context, index) {
                          final contact = state.results[index];
                          return ContactTile(
                            contact: contact,
                            onTap: () {
                              // Day 4: Navigator.push -> ChatScreen for a new/existing 1:1 thread with contact.id
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
