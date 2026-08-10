import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_contacts_usecase.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final SearchContactsUseCase searchContactsUseCase;

  ContactsBloc({required this.searchContactsUseCase})
      : super(ContactsInitial()) {
    on<ContactsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onSearchChanged(
    ContactsSearchChanged event,
    Emitter<ContactsState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(ContactsInitial());
      return;
    }
    emit(ContactsLoading());
    final result = await searchContactsUseCase(SearchContactsParams(query));
    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (contacts) => emit(ContactsLoaded(contacts)),
    );
  }
}
