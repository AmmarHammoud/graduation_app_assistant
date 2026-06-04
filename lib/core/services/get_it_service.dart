import 'package:get_it/get_it.dart';

// Existing Imports
import '../../features/auth/data/repo/auth_repo_imp.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import 'api_service.dart';
import 'database_service.dart';

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
}