import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../domain/repo/profile_repo.dart';

class ProfileRepoImp implements ProfileRepo {
  final DatabaseService databaseService;

  ProfileRepoImp({required this.databaseService});

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final data = await databaseService.getData(endpoint: BackendEndPoint.profile);
      final userModel = UserModel.fromJson(data['data']);
      return Right(userModel.toEntity());
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user) async {
    try {
      final data = {
        'name': user.name,
        'email': user.email,
      };

      // If profile picture is provided, handle multipart
      if (user.profilePicUrl != null && user.profilePicUrl!.startsWith('/')) {
        // Assuming profilePicUrl is a local file path for upload
        final file = File(user.profilePicUrl!);
        final formData = FormData.fromMap({
          ...data,
          'profile_picture': await MultipartFile.fromFile(file.path),
        });
        final response = await databaseService.updateData(endpoint: BackendEndPoint.profile, data: formData);
        final userModel = UserModel.fromJson(response);
        return Right(userModel.toEntity());
      } else {
        final response = await databaseService.updateData(endpoint: BackendEndPoint.profile, data: data);
        final userModel = UserModel.fromJson(response);
        return Right(userModel.toEntity());
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
