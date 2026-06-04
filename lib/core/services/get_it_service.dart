// import 'package:get_it/get_it.dart';
//
// import '../../features/auth/data/repo/auth_repo_imp.dart';
// import '../../features/auth/domain/repo/auth_repo.dart';
// import '../../features/profile/data/repo/profile_repo_imp.dart';
// import '../../features/profile/domain/repo/profile_repo.dart';
// import 'api_service.dart';
// import 'database_service.dart';
//
// final getIt = GetIt.instance;
//
// setupSingltonGetIt() async {
//   getIt.registerSingleton<DatabaseService>(ApiService());
//   getIt.registerSingleton<AuthRepo>(
//     AuthRepoImp(databaseService: getIt.get<DatabaseService>()),
//   );
//   getIt.registerSingleton<ProfileRepo>(
//     ProfileRepoImp(databaseService: getIt.get<DatabaseService>()),
//   );
// }

import 'package:get_it/get_it.dart';
import 'package:graduation_app_assistant/features/projects/data/datasources/assigned_projects_remote_data_source.dart';
// Existing Imports
import '../../features/auth/data/repo/auth_repo_imp.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/projects/domain/usecases/get_project_details.dart';
import '../../features/projects/presentation/cubit/assigned_project_cubit.dart';
import '../../features/projects/presentation/cubit/project_details_cubit.dart';
import 'api_service.dart';
import 'database_service.dart';

// New Project Feature Imports
import '../../features/projects/data/repositories/project_repository_impl.dart';
import '../../features/projects/domain/repositories/project_repository.dart';
import '../../features/projects/domain/usecases/get_projects.dart';

final getIt = GetIt.instance;

setupSingltonGetIt() async {
  // ==========================================
  // Core Services
  // ==========================================
  getIt.registerSingleton<DatabaseService>(ApiService());

  // ==========================================
  // Auth Feature
  // ==========================================
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImp(databaseService: getIt.get<DatabaseService>()),
  );

  // ==========================================
  // Projects Feature
  // ==========================================

  // 1. Data Source
  getIt.registerLazySingleton<AssignedProjectsRemoteDataSource>(
        () => AssignedProjectsRemoteDataSource(databaseService: getIt.get<DatabaseService>()),
  );

  // 2. Repository Implementation
  getIt.registerLazySingleton<ProjectRepository>(
        () => ProjectRepositoryImpl(remoteDataSource: getIt.get<AssignedProjectsRemoteDataSource>()),
  );

  // 3. Domain Use Cases
  getIt.registerLazySingleton(() => GetProjects(getIt.get<ProjectRepository>()));

  // 4. Presentation Cubit (Factory ensures a fresh instance per page view lifecycle)
  getIt.registerFactory(() => AssignedProjectsCubit(getProjects: getIt.get<GetProjects>()));

  // Add this inside setupSingltonGetIt()
  getIt.registerLazySingleton(() => GetProjectDetails(getIt.get<ProjectRepository>()));
  getIt.registerFactory(() => ProjectDetailsCubit(getProjectDetails: getIt.get<GetProjectDetails>()));
}