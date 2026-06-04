// import 'package:get_it/get_it.dart';
// import 'package:graduation_app_assistant/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:graduation_app_assistant/features/auth/domain/repositories/auth_repository.dart';
// import 'package:graduation_app_assistant/features/auth/domain/usecases/login_user.dart';
// import 'package:graduation_app_assistant/features/auth/presentation/bloc/auth_bloc.dart';
//
// final sl = GetIt.instance;
//
// void init() {
//   // BLoC
//   sl.registerFactory(
//     () => AuthBloc(
//       loginUser: sl(),
//     ),
//   );
//
//   // Use cases
//   sl.registerLazySingleton(() => LoginUser(sl()));
//
//   // Repository
//   sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
// }
