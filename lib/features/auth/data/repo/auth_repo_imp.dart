import 'package:dartz/dartz.dart';

import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/token_storage.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../../domain/repo/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  final DatabaseService databaseService;

  AuthRepoImp({required this.databaseService});
  @override
  Future<Either<Failure, void>> signIn(String email, String password) async {
    try {
      final data = await databaseService.addData(
        endpoint: BackendEndPoint.signIn,
        data: {"internal_id": email, "password": password},
      );
      await TokenStorage().saveAccess(data["data"]["token"]);
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(
    String name,
    String phoneNumber,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      await databaseService.addData(
        endpoint: BackendEndPoint.signUp,
        data: {
          "name": name,
          "phone": phoneNumber,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verfyEmail({
    required String code,
    required String email,
  }) async {
    try {
      await databaseService.addData(
        endpoint: BackendEndPoint.verifyEmail,
        data: {"email": email, "verification_code": code},
      );
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerficationCode({
    required String email,
  }) async {
    try {
      await databaseService.addData(
        endpoint: BackendEndPoint.resendVerificationCode,
        data: {"email": email},
      );
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword({required String email}) async {
    try {
      await databaseService.addData(
        endpoint: BackendEndPoint.forgotPassword,
        data: {"email": email},
      );
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> checkCodeResetPassword({
    required String code,
    required String email,
  }) async {
    try {
      await databaseService.addData(
        endpoint: BackendEndPoint.checkCode,
        data: {"email": email, "code": code},
      );
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String password,
    required String passwordConfirmation,
    required String email,
  }) async {
    try {
      await databaseService.addData(
        endpoint: BackendEndPoint.resetPassword,
        data: {
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
      );
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await databaseService.getData(endpoint: BackendEndPoint.signOut);
      await TokenStorage().clear();
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
