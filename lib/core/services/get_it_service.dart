import 'package:get_it/get_it.dart';
import 'package:graduation_app_assistant/features/projects/data/datasources/assigned_projects_remote_data_source.dart';

// Existing Core & Feature Imports
import '../../features/auth/data/repo/auth_repo_imp.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/profile/data/repo/profile_repo_imp.dart';
import '../../features/profile/domain/repo/profile_repo.dart';
import 'api_service.dart';
import 'database_service.dart';

// Projects Feature Imports
import '../../features/projects/data/repositories/project_repository_impl.dart';
import '../../features/projects/domain/repositories/project_repository.dart';
import '../../features/projects/domain/usecases/get_projects.dart';
import '../../features/projects/domain/usecases/get_project_details.dart';
import '../../features/projects/domain/usecases/get_work_item_update_details.dart'; // 🆕 Added
import '../../features/projects/presentation/cubit/assigned_project_cubit.dart';
import '../../features/projects/presentation/cubit/assigned_project_details_cubit.dart';
import '../../features/projects/presentation/cubit/item_update_cubit.dart'; // 🆕 Added

// Project Images Feature Imports
import '../../features/project_images/data/datasources/project_images_remote_data_source.dart';
import '../../features/project_images/data/repositories/project_images_repository_impl.dart';
import '../../features/project_images/domain/repositories/project_images_repository.dart';
import '../../features/project_images/domain/usecases/project_images_usecases.dart';
import '../../features/project_images/presentation/cubits/project_images_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupSingltonGetIt() async {
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
  // Profile Feature
  // ==========================================
  getIt.registerSingleton<ProfileRepo>(
    ProfileRepoImp(databaseService: getIt.get<DatabaseService>()),
  );

  // ==========================================
  // Projects Feature
  // ==========================================

  // 1. Data Source
  getIt.registerLazySingleton<AssignedProjectsRemoteDataSource>(
        () => AssignedProjectsRemoteDataSource(getIt.get<DatabaseService>()),
  );

  // 2. Repository Implementation
  getIt.registerLazySingleton<ProjectRepository>(
        () => ProjectRepositoryImpl(remoteDataSource: getIt.get<AssignedProjectsRemoteDataSource>()),
  );

  // 3. Domain Use Cases
  getIt.registerLazySingleton(() => GetProjects(getIt.get<ProjectRepository>()));
  getIt.registerLazySingleton(() => GetProjectDetails(getIt.get<ProjectRepository>()));
  getIt.registerLazySingleton(() => GetWorkItemUpdateDetails(getIt.get<AssignedProjectsRemoteDataSource>())); // 🆕 Fixed DI Type mismatch

  // 4. Presentation Cubits (Factories ensure fresh instances per view lifecycle)
  getIt.registerFactory(() => AssignedProjectsCubit(getProjects: getIt.get<GetProjects>()));
  getIt.registerFactory(() => AssignedProjectDetailsCubit(getProjectDetails: getIt.get<GetProjectDetails>()));

  // 🆕 Added Item Update Cubit
  getIt.registerFactory(() => ItemUpdateCubit(
    getWorkItemUpdateDetails: getIt.get<GetWorkItemUpdateDetails>(),
  ));

  // ==========================================
  // Project Images Feature (🆕 Added)
  // ==========================================

  // 1. Data Source
  getIt.registerLazySingleton<ProjectImagesRemoteDataSource>(
    () => ProjectImagesRemoteDataSourceImpl(getIt.get<DatabaseService>()),
  );

  // 2. Repository
  getIt.registerLazySingleton<ProjectImagesRepository>(
    () => ProjectImagesRepositoryImpl(remoteDataSource: getIt.get<ProjectImagesRemoteDataSource>()),
  );

  // 3. Domain Use Cases
  getIt.registerLazySingleton(() => GetProjectImagesUseCase(getIt.get<ProjectImagesRepository>()));
  getIt.registerLazySingleton(() => UploadProjectImageUseCase(getIt.get<ProjectImagesRepository>()));
  getIt.registerLazySingleton(() => DeleteProjectImageUseCase(getIt.get<ProjectImagesRepository>()));

  // 4. Presentation Cubit Factory
  getIt.registerFactory(() => ProjectImagesCubit(
    getProjectImagesUseCase: getIt.get<GetProjectImagesUseCase>(),
    uploadProjectImageUseCase: getIt.get<UploadProjectImageUseCase>(),
    deleteProjectImageUseCase: getIt.get<DeleteProjectImageUseCase>(),
  ));
}