import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/api_client.dart';
import '../security/key_manager.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_pin_usecase.dart';
import '../../features/auth/domain/usecases/login_with_gmail_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Chat
import '../../features/chat/data/datasources/chat_remote_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_user_chats_usecase.dart';
import '../../features/chat/presentation/bloc/chat_list_bloc.dart';

// Contacts
import '../../features/contacts/data/datasources/contacts_remote_data_source.dart';
import '../../features/contacts/data/repositories/contacts_repository_impl.dart';
import '../../features/contacts/domain/repositories/contacts_repository.dart';
import '../../features/contacts/domain/usecases/search_contacts_usecase.dart';
import '../../features/contacts/presentation/bloc/contacts_bloc.dart';

// Profile
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => KeyManager(secureStorage: sl()));
  sl.registerLazySingleton(() => ApiClient(secureStorage: sl()));

  // Auth feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        remoteDataSource: sl(), keyManager: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPinUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGmailUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(
        sendOtpUseCase: sl(),
        verifyPinUseCase: sl(),
        loginWithGmailUseCase: sl()),
  );

  // Chat feature
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetUserChatsUseCase(sl()));
  sl.registerFactory(() => ChatListBloc(getUserChatsUseCase: sl()));

  // Contacts feature
  sl.registerLazySingleton<ContactsRemoteDataSource>(
      () => ContactsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ContactsRepository>(
      () => ContactsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SearchContactsUseCase(sl()));
  sl.registerFactory(() => ContactsBloc(searchContactsUseCase: sl()));

  // Profile feature
  sl.registerFactory(() => ProfileCubit(secureStorage: sl()));
}
