import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();
  @override
  List<Object?> get props => [];
}

class ContactsSearchChanged extends ContactsEvent {
  final String query;
  const ContactsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
