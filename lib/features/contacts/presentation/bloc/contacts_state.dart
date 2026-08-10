import 'package:equatable/equatable.dart';
import '../../domain/entities/contact_entity.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();
  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> results;
  const ContactsLoaded(this.results);
  @override
  List<Object?> get props => [results];
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);
  @override
  List<Object?> get props => [message];
}
